import 'package:drift/drift.dart';

import '../../utils/date_utils_ext.dart';
import '../app_database.dart';
import '../enums.dart';
import '../tables.dart';

part 'nafl_dao.g.dart';

/// Data access for the nafl (optional prayers) checklist.
///
/// Fixed types are stored as a single row per (date, type) with
/// customName = ''; custom nafls get one row per name. "Not done" items
/// are kept as rows with done = false so skipped items stay visible.
@DriftAccessor(tables: [NaflEntries])
class NaflDao extends DatabaseAccessor<AppDatabase> with _$NaflDaoMixin {
  NaflDao(super.db);

  // ── Day checklist ───────────────────────────────────────────────────────

  /// Live rows for one day, ordered: fixed types by enum order, then
  /// custom ones alphabetically.
  Stream<List<NaflEntry>> watchDay(String date) {
    return (select(naflEntries)
          ..where((t) => t.date.equals(date))
          ..orderBy([
            (t) => OrderingTerm.asc(t.naflType),
            (t) => OrderingTerm.asc(t.customName),
          ]))
        .watch();
  }

  /// Upsert a fixed-type row (customName stays '').
  Future<void> upsertFixed({
    required String date,
    required NaflType type,
    required bool done,
    required int rakats,
    String? note,
  }) {
    return into(naflEntries).insertOnConflictUpdate(
      NaflEntriesCompanion(
        date: Value(date),
        naflType: Value(type),
        customName: const Value(''),
        done: Value(done),
        rakats: Value(rakats),
        note: Value(note),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Upsert a custom row keyed by (date, customName).
  Future<void> upsertCustom({
    required String date,
    required String name,
    required bool done,
    required int rakats,
    String? note,
  }) {
    return into(naflEntries).insertOnConflictUpdate(
      NaflEntriesCompanion(
        date: Value(date),
        naflType: const Value(NaflType.custom),
        customName: Value(name),
        done: Value(done),
        rakats: Value(rakats),
        note: Value(note),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteCustom({required String date, required String name}) {
    return (delete(naflEntries)
          ..where(
            (t) =>
                t.date.equals(date) &
                t.naflType.equals(NaflType.custom.index) &
                t.customName.equals(name),
          ))
        .go();
  }

  // ── Aggregation for stats & dashboard ───────────────────────────────────

  /// Total rakats done + item count over an inclusive ymd range.
  Future<NaflRangeTotals> rangeTotals(DateRange range) async {
    final rows = await _rangeRows(range);
    var rakats = 0;
    var doneItems = 0;
    for (final r in rows) {
      if (r.done) {
        rakats += r.rakats;
        doneItems++;
      }
    }
    return NaflRangeTotals(rakats: rakats, doneItems: doneItems);
  }

  /// Rakats grouped per nafl type (customs merged into NaflType.custom).
  /// Only rows with done = true contribute.
  Future<Map<NaflType, int>> rakatsByType(DateRange range) async {
    final rows = await _rangeRows(range);
    final map = {for (final p in NaflType.values) p: 0};
    for (final r in rows) {
      if (r.done) map[r.naflType] = (map[r.naflType] ?? 0) + r.rakats;
    }
    return map;
  }

  /// Rakats per day — powers the monthly bar chart.
  Future<Map<String, int>> rakatsByDay(DateRange range) async {
    final rows = await _rangeRows(range);
    final map = <String, int>{};
    for (final r in rows) {
      if (r.done) map[r.date] = (map[r.date] ?? 0) + r.rakats;
    }
    return map;
  }

  /// Rakats per month for a year (12 buckets, index 0 = January).
  Future<List<int>> rakatsByMonth(int year) async {
    final rows =
        await (select(naflEntries)
              ..where((t) => t.date.like('$year-%')))
            .get();
    final buckets = List.filled(12, 0);
    for (final r in rows) {
      if (!r.done) continue;
      final month = int.tryParse(r.date.substring(5, 7));
      if (month != null && month >= 1 && month <= 12) {
        buckets[month - 1] += r.rakats;
      }
    }
    return buckets;
  }

  /// Number of days in [range] with at least one nafl done.
  Future<int> daysPerformed(DateRange range) async {
    final rows = await _rangeRows(range);
    return rows.where((r) => r.done).map((r) => r.date).toSet().length;
  }

  /// Consecutive-day streak for [type], walking back from today.
  /// Pass [fardCompleteDays] to skip today when its fard prayers aren't
  /// finished yet (mirrors NamazDao.streaks behaviour).
  Future<int> typeStreak(NaflType type, {required String todayYmd}) async {
    final rows =
        await (select(naflEntries)
              ..where(
                (t) =>
                    t.naflType.equals(type.index) & t.done.equals(true),
              ))
            .get();
    final days = rows.map((r) => r.date).toSet();
    var streak = 0;
    var day = DateUtilsExt.parseYmd(todayYmd);
    if (!days.contains(todayYmd)) {
      day = day.subtract(const Duration(days: 1));
    }
    while (days.contains(DateUtilsExt.ymd(day))) {
      streak++;
      day = day.subtract(const Duration(days: 1));
    }
    return streak;
  }

  Future<List<NaflEntry>> _rangeRows(DateRange range) {
    return (select(naflEntries)
          ..where(
            (t) =>
                t.date.isBiggerOrEqualValue(range.startYmd) &
                t.date.isSmallerOrEqualValue(range.endYmd),
          ))
        .get();
  }
}

/// Total rakats + done item count over a range.
class NaflRangeTotals {
  final int rakats;
  final int doneItems;
  const NaflRangeTotals({required this.rakats, required this.doneItems});
  static const empty = NaflRangeTotals(rakats: 0, doneItems: 0);
}
