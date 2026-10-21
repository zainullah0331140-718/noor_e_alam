import 'package:drift/drift.dart';

import '../../utils/date_utils_ext.dart';
import '../app_database.dart';
import '../enums.dart';
import '../tables.dart';

part 'qaza_dao.g.dart';

/// Data access for the qaza (missed-prayer) ledger.
///
/// Pending qaza = rows with isMadeUp = false. "Mark as made up" flips the
/// flag instead of deleting, giving us a free history log.
@DriftAccessor(tables: [QazaRecords])
class QazaDao extends DatabaseAccessor<AppDatabase> with _$QazaDaoMixin {
  QazaDao(super.db);

  /// Live pending count per prayer type.
  Stream<Map<NamazType, int>> watchPendingCounts() {
    return (select(qazaRecords)..where((q) => q.isMadeUp.equals(false)))
        .watch()
        .map(_tally);
  }

  /// Live full history (pending first, newest first).
  Stream<List<QazaRecord>> watchAll() {
    return (select(qazaRecords)
          ..orderBy([
            (q) => OrderingTerm.asc(q.isMadeUp),
            (q) => OrderingTerm.desc(q.createdAt),
          ]))
        .watch();
  }

  /// Manually add old/legacy qaza (e.g. rakats missed years ago).
  Future<void> addManual({
    required NamazType prayer,
    int rakats = 1,
    String? note,
  }) {
    return into(qazaRecords).insert(
      QazaRecordsCompanion.insert(
        prayer: prayer,
        rakats: Value(rakats),
        logDate: DateUtilsExt.ymd(DateTime.now()),
        source: const Value('manual'),
        note: Value(note),
      ),
    );
  }

  /// Mark one pending row as made up (stamps today as madeUpDate).
  Future<void> markMadeUp(int id) {
    return (update(qazaRecords)..where((q) => q.id.equals(id))).write(
      QazaRecordsCompanion(
        isMadeUp: const Value(true),
        madeUpDate: Value(DateUtilsExt.ymd(DateTime.now())),
      ),
    );
  }

  /// Clear one rakat from a prayer's pending balance: marks the oldest
  /// pending row as made up, or — if it covers multiple rakats — splits
  /// one rakat into a made-up history row and keeps the rest pending.
  Future<void> clearOneRakat(NamazType prayer) async {
    final pending =
        await (select(qazaRecords)
              ..where(
                (q) =>
                    q.prayer.equals(prayer.index) & q.isMadeUp.equals(false),
              )
              ..orderBy([(q) => OrderingTerm.asc(q.createdAt)])
              ..limit(1))
            .getSingleOrNull();
    if (pending == null) return;
    final today = DateUtilsExt.ymd(DateTime.now());
    if (pending.rakats <= 1) {
      await markMadeUp(pending.id);
    } else {
      await transaction(() async {
        // Shrink the original pending row by one rakat.
        await (update(qazaRecords)..where((q) => q.id.equals(pending.id)))
            .write(QazaRecordsCompanion(rakats: Value(pending.rakats - 1)));
        // Record the cleared rakat as its own made-up history row.
        await into(qazaRecords).insert(
          QazaRecordsCompanion.insert(
            prayer: prayer,
            rakats: const Value(1),
            logDate: pending.logDate,
            source: Value(pending.source),
            note: Value(pending.note),
            isMadeUp: const Value(true),
            madeUpDate: Value(today),
            createdAt: Value(DateTime.now()),
          ),
        );
      });
    }
  }

  Map<NamazType, int> _tally(List<QazaRecord> rows) {
    final map = {for (final p in NamazType.values) p: 0};
    for (final r in rows) {
      if (!r.isMadeUp) map[r.prayer] = (map[r.prayer] ?? 0) + r.rakats;
    }
    return map;
  }
}
