import 'package:drift/drift.dart';

import '../../utils/date_utils_ext.dart';
import '../../utils/streak_utils.dart';
import '../app_database.dart';
import '../enums.dart';
import '../tables.dart';

part 'gheebat_dao.g.dart';

/// Aggregated Gheebat counts for an inclusive range.
class GheebatRangeTotals {
  final int free;
  final int slipped;
  final int notRecorded;
  final int daysTotal;

  const GheebatRangeTotals({
    this.free = 0,
    this.slipped = 0,
    this.notRecorded = 0,
    this.daysTotal = 0,
  });

  int get recorded => free + slipped;

  /// Share of recorded days that were gheebat-free (0..1).
  double get freePercent => recorded == 0 ? 0 : free / recorded;
}

/// Data access for the Gheebat (backbiting) tracker.
@DriftAccessor(tables: [GheebatEntries])
class GheebatDao extends DatabaseAccessor<AppDatabase>
    with _$GheebatDaoMixin {
  GheebatDao(super.db);

  // ── Daily check-in ──────────────────────────────────────────────────────

  /// Live row for one day, or null when the day has no check-in yet.
  Stream<GheebatEntry?> watchDay(String date) {
    return (select(
      gheebatEntries,
    )..where((t) => t.date.equals(date))).watchSingleOrNull();
  }

  Future<GheebatEntry?> getDay(String date) {
    return (select(
      gheebatEntries,
    )..where((t) => t.date.equals(date))).getSingleOrNull();
  }

  /// Sets the day's status, optionally replacing the private note.
  Future<void> setStatus({
    required String date,
    required GheebatStatus status,
    String? note,
  }) async {
    final existing = await getDay(date);
    await into(gheebatEntries).insertOnConflictUpdate(
      GheebatEntriesCompanion.insert(
        date: date,
        status: Value(status),
        note: Value(note ?? existing?.note),
        istighfarCount: Value(existing?.istighfarCount ?? 0),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Stores the private reflection without changing the status.
  Future<void> setNote({required String date, required String? note}) async {
    final existing = await getDay(date);
    await into(gheebatEntries).insertOnConflictUpdate(
      GheebatEntriesCompanion.insert(
        date: date,
        status: Value(existing?.status ?? GheebatStatus.notRecorded),
        note: Value(note),
        istighfarCount: Value(existing?.istighfarCount ?? 0),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Adds [delta] istighfar repetitions to the day (never below zero).
  Future<void> incrementIstighfar(String date, {int delta = 1}) async {
    final existing = await getDay(date);
    final next = (existing?.istighfarCount ?? 0) + delta;
    await into(gheebatEntries).insertOnConflictUpdate(
      GheebatEntriesCompanion.insert(
        date: date,
        status: Value(existing?.status ?? GheebatStatus.notRecorded),
        note: Value(existing?.note),
        istighfarCount: Value(next < 0 ? 0 : next),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Removes the check-in for one day.
  Future<int> resetDay(String date) {
    return (delete(gheebatEntries)..where((t) => t.date.equals(date))).go();
  }

  // ── Aggregates ──────────────────────────────────────────────────────────

  /// Free / slipped / not-recorded counts for [range].
  Future<GheebatRangeTotals> rangeTotals(DateRange range) async {
    final rows =
        await (select(gheebatEntries)..where(
              (t) =>
                  t.date.isBiggerOrEqualValue(range.startYmd) &
                  t.date.isSmallerOrEqualValue(range.endYmd),
            ))
            .get();
    var free = 0;
    var slipped = 0;
    for (final row in rows) {
      switch (row.status) {
        case GheebatStatus.free:
          free++;
        case GheebatStatus.slipped:
          slipped++;
        case GheebatStatus.notRecorded:
          break;
      }
    }
    final days = daysInRange(range.startYmd, range.endYmd);
    return GheebatRangeTotals(
      free: free,
      slipped: slipped,
      notRecorded: days - free - slipped,
      daysTotal: days,
    );
  }

  /// Status per `yyyy-MM-dd` inside [range] (heatmap source).
  Future<Map<String, GheebatStatus>> statusByDay(DateRange range) async {
    final rows =
        await (select(gheebatEntries)..where(
              (t) =>
                  t.date.isBiggerOrEqualValue(range.startYmd) &
                  t.date.isSmallerOrEqualValue(range.endYmd),
            ))
            .get();
    return {for (final row in rows) row.date: row.status};
  }

  /// Current + best streak of gheebat-free days.
  Future<StreakResult> streaks({required String todayYmd}) async {
    final rows =
        await (select(gheebatEntries)..where(
              (t) =>
                  t.status.equalsValue(GheebatStatus.free) &
                  t.date.isSmallerOrEqualValue(todayYmd),
            ))
            .get();
    return computeStreak(
      completedDays: rows.map((r) => r.date).toSet(),
      todayYmd: todayYmd,
    );
  }

  /// Gheebat-free day count for each month of [year] (index 0 = January).
  Future<List<int>> freeByMonth(int year) async {
    final rows =
        await (select(gheebatEntries)..where(
              (t) =>
                  t.status.equalsValue(GheebatStatus.free) &
                  t.date.like('$year-%'),
            ))
            .get();
    final months = List<int>.filled(12, 0);
    for (final row in rows) {
      final month = int.parse(row.date.substring(5, 7));
      if (month >= 1 && month <= 12) months[month - 1]++;
    }
    return months;
  }

  /// Number of checked-in days (free + slipped) for each month of [year].
  Future<List<int>> recordedByMonth(int year) async {
    final rows =
        await (select(gheebatEntries)..where(
              (t) =>
                  (t.status.equalsValue(GheebatStatus.free) |
                      t.status.equalsValue(GheebatStatus.slipped)) &
                  t.date.like('$year-%'),
            ))
            .get();
    final months = List<int>.filled(12, 0);
    for (final row in rows) {
      final month = int.parse(row.date.substring(5, 7));
      if (month >= 1 && month <= 12) months[month - 1]++;
    }
    return months;
  }
}
