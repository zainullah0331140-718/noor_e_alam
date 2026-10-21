import 'package:drift/drift.dart';

import '../../utils/date_utils_ext.dart' show DateRange;
import '../../utils/streak_utils.dart';
import '../app_database.dart';
import '../enums.dart';
import '../tables.dart';

part 'tilawat_dao.g.dart';

/// Per-day Tilawat totals, broken down by unit.
class TilawatDayTotals {
  final int pages;
  final int ruku;
  final int para;
  final int minutes;

  /// Number of log entries for the day.
  final int entries;

  const TilawatDayTotals({
    this.pages = 0,
    this.ruku = 0,
    this.para = 0,
    this.minutes = 0,
    this.entries = 0,
  });

  /// Total quantity for a given unit — drives the heatmap intensity.
  int amountFor(TilawatUnit unit) {
    switch (unit) {
      case TilawatUnit.pages:
        return pages;
      case TilawatUnit.ruku:
        return ruku;
      case TilawatUnit.para:
        return para;
      case TilawatUnit.minutes:
        return minutes;
    }
  }
}

/// Inclusive-range Tilawat totals.
class TilawatRangeTotals {
  final int pages;
  final int ruku;
  final int para;
  final int minutes;

  /// Number of days with at least one entry.
  final int days;

  /// Number of individual log entries.
  final int entries;

  const TilawatRangeTotals({
    this.pages = 0,
    this.ruku = 0,
    this.para = 0,
    this.minutes = 0,
    this.days = 0,
    this.entries = 0,
  });

  int amountFor(TilawatUnit unit) {
    switch (unit) {
      case TilawatUnit.pages:
        return pages;
      case TilawatUnit.ruku:
        return ruku;
      case TilawatUnit.para:
        return para;
      case TilawatUnit.minutes:
        return minutes;
    }
  }

  /// Average amount per day (rounded) for the selected unit.
  int averagePerDay(TilawatUnit unit) {
    if (days == 0) return 0;
    return (amountFor(unit) / days).round();
  }
}

/// Data access for the Tilawat (Quran recitation) module.
@DriftAccessor(tables: [TilawatEntries, TilawatPositions])
class TilawatDao extends DatabaseAccessor<AppDatabase> with _$TilawatDaoMixin {
  TilawatDao(super.db);

  // ── Daily log ───────────────────────────────────────────────────────────

  /// Live list of entries for one day, oldest first.
  Stream<List<TilawatEntry>> watchDay(String date) {
    return (select(tilawatEntries)
          ..where((t) => t.date.equals(date))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
        .watch();
  }

  /// Adds one recitation entry.
  Future<int> addEntry({
    required String date,
    required TilawatUnit unit,
    required int amount,
    String? note,
  }) {
    return into(tilawatEntries).insert(
      TilawatEntriesCompanion.insert(
        date: date,
        unit: unit,
        amount: Value(amount),
        note: Value(note),
      ),
    );
  }

  Future<int> deleteEntry(int id) {
    return (delete(tilawatEntries)..where((t) => t.id.equals(id))).go();
  }

  // ── Aggregates ──────────────────────────────────────────────────────────

  /// Per-day totals for a range, keyed by `yyyy-MM-dd`.
  Future<Map<String, TilawatDayTotals>> dayTotals(DateRange range) async {
    final query = selectOnly(tilawatEntries)
      ..addColumns([
        tilawatEntries.date,
        tilawatEntries.unit,
        tilawatEntries.amount.sum(),
        tilawatEntries.id.count(),
      ])
      ..where(
        tilawatEntries.date.isBiggerOrEqualValue(range.startYmd) &
            tilawatEntries.date.isSmallerOrEqualValue(range.endYmd),
      )
      ..groupBy([tilawatEntries.date, tilawatEntries.unit]);

    final rows = await query.get();
    final builder = <String, _TotalsBuilder>{};
    for (final row in rows) {
      final date = row.read(tilawatEntries.date)!;
      final unit = TilawatUnit.values[row.read(tilawatEntries.unit)!];
      final sum = row.read(tilawatEntries.amount.sum()) ?? 0;
      final count = row.read(tilawatEntries.id.count()) ?? 0;
      final b = builder.putIfAbsent(date, _TotalsBuilder.new);
      switch (unit) {
        case TilawatUnit.pages:
          b.pages += sum;
        case TilawatUnit.ruku:
          b.ruku += sum;
        case TilawatUnit.para:
          b.para += sum;
        case TilawatUnit.minutes:
          b.minutes += sum;
      }
      b.entries += count;
    }
    return builder.map((k, v) => MapEntry(k, v.build()));
  }

  /// Totals over an inclusive range.
  Future<TilawatRangeTotals> rangeTotals(DateRange range) async {
    final byDay = await dayTotals(range);
    var pages = 0, ruku = 0, para = 0, minutes = 0, entries = 0;
    for (final t in byDay.values) {
      pages += t.pages;
      ruku += t.ruku;
      para += t.para;
      minutes += t.minutes;
      entries += t.entries;
    }
    return TilawatRangeTotals(
      pages: pages,
      ruku: ruku,
      para: para,
      minutes: minutes,
      days: byDay.length,
      entries: entries,
    );
  }

  /// Total pages recorded in each month of [year] (index 0 = January).
  Future<List<int>> pagesByMonth(int year) async {
    final query = selectOnly(tilawatEntries)
      ..addColumns([tilawatEntries.date, tilawatEntries.amount.sum()])
      ..where(
        tilawatEntries.date.like('$year-%') &
            tilawatEntries.unit.equalsValue(TilawatUnit.pages),
      )
      ..groupBy([tilawatEntries.date]);
    final rows = await query.get();
    final months = List<int>.filled(12, 0);
    for (final row in rows) {
      final date = row.read(tilawatEntries.date)!;
      final sum = row.read(tilawatEntries.amount.sum()) ?? 0;
      final month = int.parse(date.substring(5, 7));
      if (month >= 1 && month <= 12) months[month - 1] += sum;
    }
    return months;
  }

  /// Days (within [range]) where the recitation goal was met.
  Future<int> daysMeetingGoal(
    DateRange range, {
    required TilawatUnit unit,
    required int goal,
  }) async {
    if (goal <= 0) return 0;
    final byDay = await dayTotals(range);
    return byDay.values.where((t) => t.amountFor(unit) >= goal).length;
  }

  /// Current + best streak of days with at least one entry.
  Future<StreakResult> streaks({required String todayYmd}) async {
    final query = selectOnly(tilawatEntries)
      ..addColumns([tilawatEntries.date])
      ..where(tilawatEntries.date.isSmallerOrEqualValue(todayYmd))
      ..groupBy([tilawatEntries.date]);
    final rows = await query.get();
    final days = rows.map((r) => r.read(tilawatEntries.date)!).toSet();
    return computeStreak(completedDays: days, todayYmd: todayYmd);
  }

  // ── Reading position ────────────────────────────────────────────────────

  /// The saved reading position (single row), or null before first save.
  Future<TilawatPosition?> getPosition() {
    return (select(tilawatPositions)..where((t) => t.id.equals(1)))
        .getSingleOrNull();
  }

  /// Upserts the single reading-position row.
  Future<void> savePosition({
    required int para,
    required String surah,
    required int page,
  }) {
    return into(tilawatPositions).insertOnConflictUpdate(
      TilawatPositionsCompanion.insert(
        para: Value(para),
        surah: Value(surah),
        page: Value(page),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}

/// Mutable accumulator used while folding grouped query rows.
class _TotalsBuilder {
  int pages = 0;
  int ruku = 0;
  int para = 0;
  int minutes = 0;
  int entries = 0;

  TilawatDayTotals build() => TilawatDayTotals(
    pages: pages,
    ruku: ruku,
    para: para,
    minutes: minutes,
    entries: entries,
  );
}
