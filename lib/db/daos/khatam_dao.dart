import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'khatam_dao.g.dart';

/// Data access for the Quran Khatam (completion cycle) module.
@DriftAccessor(tables: [Khatams, KhatamParas])
class KhatamDao extends DatabaseAccessor<AppDatabase> with _$KhatamDaoMixin {
  KhatamDao(super.db);

  /// All khatams, newest first.
  Stream<List<Khatam>> watchAll() {
    return (select(khatams)
          ..orderBy([(t) => OrderingTerm.desc(t.id)]))
        .watch();
  }

  /// The currently active khatam (no end date), if any.
  Stream<Khatam?> watchActive() {
    return (select(khatams)
          ..where((t) => t.endDate.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.id)])
          ..limit(1))
        .watchSingleOrNull();
  }

  /// Starts a new khatam and returns its id.
  Future<int> startKhatam({required String startDate}) {
    return into(khatams).insert(
      KhatamsCompanion.insert(startDate: startDate),
    );
  }

  /// Marks a khatam complete (stamps the end date).
  Future<void> completeKhatam(int id, {required String endDate}) {
    return (update(khatams)..where((t) => t.id.equals(id))).write(
      KhatamsCompanion(endDate: Value(endDate)),
    );
  }

  // ── Para checklist ──────────────────────────────────────────────────────

  /// Para numbers marked done inside [khatamId].
  Stream<Set<int>> watchDoneParas(int khatamId) {
    return (select(khatamParas)..where(
          (t) => t.khatamId.equals(khatamId) & t.done.equals(true),
        ))
        .watch()
        .map((rows) => rows.map((r) => r.para).toSet());
  }

  /// Number of completed paras in [khatamId].
  Future<int> completedParas(int khatamId) async {
    final countExp = khatamParas.para.count();
    final query = selectOnly(khatamParas)
      ..addColumns([countExp])
      ..where(khatamParas.khatamId.equals(khatamId) & khatamParas.done.equals(true));
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  /// Sets one para's done state.
  Future<void> setParaDone(
    int khatamId,
    int para, {
    required bool done,
    required String date,
  }) {
    return into(khatamParas).insertOnConflictUpdate(
      KhatamParasCompanion.insert(
        khatamId: khatamId,
        para: para,
        done: Value(done),
        doneDate: Value(done ? date : null),
      ),
    );
  }

  /// Marks every para up to [throughPara] done — used to sync with the
  /// current Tilawat reading position.
  Future<void> markParasThrough(
    int khatamId,
    int throughPara, {
    required String date,
  }) async {
    final clamped = throughPara.clamp(1, 30);
    await batch((b) {
      for (var para = 1; para <= clamped; para++) {
        b.insert(
          khatamParas,
          KhatamParasCompanion.insert(
            khatamId: khatamId,
            para: para,
            done: const Value(true),
            doneDate: Value(date),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  // ── Counters ────────────────────────────────────────────────────────────

  /// Number of completed khatams whose end date falls in [year].
  Future<int> countInYear(int year) async {
    final rows = await (select(khatams)..where(
          (t) => t.endDate.like('$year-%'),
        ))
        .get();
    return rows.length;
  }

  /// Total completed khatams, all time.
  Future<int> countAll() async {
    final rows = await (select(khatams)..where((t) => t.endDate.isNotNull()))
        .get();
    return rows.length;
  }

  /// Completed khatams grouped by end year (for the yearly bar chart).
  Future<Map<int, int>> completedByYear() async {
    final rows = await (select(khatams)..where((t) => t.endDate.isNotNull()))
        .get();
    final map = <int, int>{};
    for (final row in rows) {
      final year = int.tryParse(row.endDate!.substring(0, 4));
      if (year != null) map[year] = (map[year] ?? 0) + 1;
    }
    return map;
  }
}
