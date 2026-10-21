import 'package:drift/drift.dart';

import '../../utils/date_utils_ext.dart' show DateRange;
import '../../utils/streak_utils.dart';
import '../app_database.dart';
import '../tables.dart';

part 'azkar_dao.g.dart';

/// Data access for the Azkar (dhikr remembrance) module.
@DriftAccessor(tables: [AzkarEntries, CustomDhikrs])
class AzkarDao extends DatabaseAccessor<AppDatabase> with _$AzkarDaoMixin {
  AzkarDao(super.db);

  // ── Daily counts ────────────────────────────────────────────────────────

  /// Live rows for one day (only dhikr that have been touched).
  Stream<List<AzkarEntry>> watchDay(String date) {
    return (select(azkarEntries)..where((t) => t.date.equals(date))).watch();
  }

  /// Live custom dhikr definitions (active only), oldest first.
  Stream<List<CustomDhikr>> watchCustomDhikrs() {
    return (select(customDhikrs)
          ..where((t) => t.active.equals(true))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
        .watch();
  }

  /// Inserts or updates the count for one dhikr on one day.
  Future<void> setCount({
    required String date,
    required String dhikrKey,
    required int count,
    required int target,
  }) {
    return into(azkarEntries).insertOnConflictUpdate(
      AzkarEntriesCompanion.insert(
        date: date,
        dhikrKey: dhikrKey,
        count: Value(count < 0 ? 0 : count),
        target: Value(target),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Increments a counter by [delta] (default +1) and auto-saves.
  Future<void> increment({
    required String date,
    required String dhikrKey,
    required int target,
    int delta = 1,
  }) async {
    final existing =
        await (select(azkarEntries)
              ..where((t) => t.date.equals(date) & t.dhikrKey.equals(dhikrKey)))
            .getSingleOrNull();
    final next = (existing?.count ?? 0) + delta;
    await setCount(
      date: date,
      dhikrKey: dhikrKey,
      count: next < 0 ? 0 : next,
      target: target,
    );
  }

  /// Resets every counter for one day back to zero.
  Future<void> resetDay(String date) async {
    await (update(azkarEntries)..where((t) => t.date.equals(date)))
        .write(const AzkarEntriesCompanion(count: Value(0)));
  }

  // ── Custom dhikr CRUD ───────────────────────────────────────────────────

  Future<int> addCustom({
    required String name,
    String arabicText = '',
    int target = 33,
    String? reminderTime,
  }) {
    return into(customDhikrs).insert(
      CustomDhikrsCompanion.insert(
        name: name,
        arabicText: Value(arabicText),
        target: Value(target),
        reminderTime: Value(reminderTime),
      ),
    );
  }

  /// Soft-deletes a custom dhikr so its historical counts remain.
  Future<int> deactivateCustom(int id) {
    return (update(customDhikrs)..where((t) => t.id.equals(id))).write(
      const CustomDhikrsCompanion(active: Value(false)),
    );
  }

  // ── Aggregates ──────────────────────────────────────────────────────────

  /// Sum of counts per dhikr key over [range].
  Future<Map<String, int>> totalsByDhikr(DateRange range) async {
    final query = selectOnly(azkarEntries)
      ..addColumns([azkarEntries.dhikrKey, azkarEntries.count.sum()])
      ..where(
        azkarEntries.date.isBiggerOrEqualValue(range.startYmd) &
            azkarEntries.date.isSmallerOrEqualValue(range.endYmd),
      )
      ..groupBy([azkarEntries.dhikrKey]);
    final rows = await query.get();
    return {
      for (final row in rows)
        row.read(azkarEntries.dhikrKey)!:
            row.read(azkarEntries.count.sum()) ?? 0,
    };
  }

  /// Sum of all counts per day over [range] (for the bar chart).
  Future<Map<String, int>> totalsByDay(DateRange range) async {
    final query = selectOnly(azkarEntries)
      ..addColumns([azkarEntries.date, azkarEntries.count.sum()])
      ..where(
        azkarEntries.date.isBiggerOrEqualValue(range.startYmd) &
            azkarEntries.date.isSmallerOrEqualValue(range.endYmd),
      )
      ..groupBy([azkarEntries.date]);
    final rows = await query.get();
    return {
      for (final row in rows)
        row.read(azkarEntries.date)!:
            row.read(azkarEntries.count.sum()) ?? 0,
    };
  }

  /// Days in [range] where every key in [keys] reached its stored target.
  Future<Set<String>> fullyDoneDays(
    DateRange range,
    List<String> keys,
  ) async {
    if (keys.isEmpty) return <String>{};
    final rows = await (select(azkarEntries)..where(
          (t) =>
              t.date.isBiggerOrEqualValue(range.startYmd) &
              t.date.isSmallerOrEqualValue(range.endYmd) &
              t.dhikrKey.isIn(keys),
        ))
        .get();
    final byDate = <String, Set<String>>{};
    for (final row in rows) {
      if (row.count >= row.target) {
        byDate.putIfAbsent(row.date, () => <String>{}).add(row.dhikrKey);
      }
    }
    return {
      for (final entry in byDate.entries)
        if (entry.value.length >= keys.length) entry.key,
    };
  }

  /// Current + best streak of days where all [keys] were completed.
  Future<StreakResult> streaks({
    required String todayYmd,
    required List<String> keys,
  }) async {
    // Scan back up to one year so the query stays bounded.
    final today = DateTime.parse(todayYmd);
    final range = DateRange(
      startYmd: _ymd(today.subtract(const Duration(days: 365))),
      endYmd: todayYmd,
    );
    final days = await fullyDoneDays(range, keys);
    return computeStreak(completedDays: days, todayYmd: todayYmd);
  }
}

/// Minimal local ymd formatter to avoid a utils import cycle.
String _ymd(DateTime d) {
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '${d.year}-$m-$day';
}
