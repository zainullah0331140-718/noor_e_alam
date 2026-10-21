import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/daos/namaz_dao.dart';
import '../db/daos/tilawat_dao.dart';
import '../db/enums.dart';
import '../utils/azkar_catalog.dart';
import '../utils/date_utils_ext.dart';
import 'azkar_providers.dart';
import 'khatam_providers.dart';
import 'nafl_providers.dart';
import 'namaz_providers.dart';
import 'tilawat_providers.dart';

/// Report-ready data bundles for the Namaz module.
///
/// These are the "print hooks": pure, serialisable snapshots of day / month
/// / year namaz activity, consumed by the upcoming Reports phase.
class NamazReport {
  final DateRange range;
  final String rangeLabel;
  final NamazRangeCounts totals;
  final int currentStreak;
  final int bestStreak;
  final Map<NamazType, int> missedByPrayer;

  const NamazReport({
    required this.range,
    required this.rangeLabel,
    required this.totals,
    required this.currentStreak,
    required this.bestStreak,
    required this.missedByPrayer,
  });

  double get jamaatPercent => totals.jamaatPercent;
}

/// Report-ready data bundle for the Nafl module.
class NaflReport {
  final DateRange range;
  final String rangeLabel;
  final int totalRakats;
  final int doneItems;
  final int daysPerformed;
  final Map<NaflType, int> rakatsByType;

  const NaflReport({
    required this.range,
    required this.rangeLabel,
    required this.totalRakats,
    required this.doneItems,
    required this.daysPerformed,
    required this.rakatsByType,
  });
}

/// Day report for the given day.
final namazDayReportProvider =
    FutureProvider.family<NamazReport, DateTime>((ref, day) async {
      final dao = ref.watch(namazDaoProvider);
      final range = DateRange.dayOf(day);
      final totals = await dao.rangeCounts(range);
      final missed = await dao.missedByPrayer(range);
      final streak = await dao.streaks(
        todayYmd: DateUtilsExt.ymd(DateTime.now()),
      );
      return NamazReport(
        range: range,
        rangeLabel: DateUtilsExt.pretty(day),
        totals: totals,
        currentStreak: streak.current,
        bestStreak: streak.best,
        missedByPrayer: missed,
      );
    });

/// Month report for the month containing [month].
final namazMonthReportProvider =
    FutureProvider.family<NamazReport, DateTime>((ref, month) async {
      final dao = ref.watch(namazDaoProvider);
      final range = DateRange.monthOf(month);
      final totals = await dao.rangeCounts(range);
      final missed = await dao.missedByPrayer(range);
      final streak = await dao.streaks(
        todayYmd: DateUtilsExt.ymd(DateTime.now()),
      );
      return NamazReport(
        range: range,
        rangeLabel: '${month.year}-${month.month.toString().padLeft(2, '0')}',
        totals: totals,
        currentStreak: streak.current,
        bestStreak: streak.best,
        missedByPrayer: missed,
      );
    });

/// Year report for [year].
final namazYearReportProvider =
    FutureProvider.family<NamazReport, int>((ref, year) async {
      final dao = ref.watch(namazDaoProvider);
      final range = DateRange.yearOf(DateTime(year));
      final totals = await dao.rangeCounts(range);
      final missed = await dao.missedByPrayer(range);
      final streak = await dao.streaks(
        todayYmd: DateUtilsExt.ymd(DateTime.now()),
      );
      return NamazReport(
        range: range,
        rangeLabel: '$year',
        totals: totals,
        currentStreak: streak.current,
        bestStreak: streak.best,
        missedByPrayer: missed,
      );
    });

/// Nafl report for an arbitrary [DateRange].
final naflReportProvider =
    FutureProvider.family<NaflReport, DateRange>((ref, range) async {
      final dao = ref.watch(naflDaoProvider);
      final totals = await dao.rangeTotals(range);
      final byType = await dao.rakatsByType(range);
      final days = await dao.daysPerformed(range);
      return NaflReport(
        range: range,
        rangeLabel: '${range.startYmd} → ${range.endYmd}',
        totalRakats: totals.rakats,
        doneItems: totals.doneItems,
        daysPerformed: days,
        rakatsByType: byType,
      );
    });

/// Nafl day report convenience.
final naflDayReportProvider =
    FutureProvider.family<NaflReport, DateTime>((ref, day) {
      return ref.watch(naflReportProvider(DateRange.dayOf(day)).future);
    });

/// Nafl month report convenience for the month containing [month].
final naflMonthReportProvider =
    FutureProvider.family<NaflReport, DateTime>((ref, month) {
      return ref.watch(naflReportProvider(DateRange.monthOf(month)).future);
    });

/// Nafl year report convenience for [year].
final naflYearReportProvider =
    FutureProvider.family<NaflReport, int>((ref, year) {
      return ref.watch(naflReportProvider(DateRange.yearOf(DateTime(year))).future);
    });

// ---------------------------------------------------------------------------
// Phase 3 print hooks: Tilawat, Azkar and Khatam reports.
// ---------------------------------------------------------------------------

/// Report-ready snapshot of Tilawat activity.
class TilawatReport {
  final DateRange range;
  final String rangeLabel;
  final TilawatRangeTotals totals;
  final TilawatUnit unit;
  final int goal;
  final int daysTotal;
  final int goalAchievedDays;
  final int currentStreak;
  final int bestStreak;

  const TilawatReport({
    required this.range,
    required this.rangeLabel,
    required this.totals,
    required this.unit,
    required this.goal,
    required this.daysTotal,
    required this.goalAchievedDays,
    required this.currentStreak,
    required this.bestStreak,
  });
}

/// Report-ready snapshot of Azkar activity.
class AzkarReport {
  final DateRange range;
  final String rangeLabel;
  final AzkarStats stats;
  final int currentStreak;
  final int bestStreak;

  const AzkarReport({
    required this.range,
    required this.rangeLabel,
    required this.stats,
    required this.currentStreak,
    required this.bestStreak,
  });
}

/// Report-ready snapshot of Khatam activity.
class KhatamReport {
  final DateRange range;
  final String rangeLabel;

  /// Khatams completed whose end date falls inside [range].
  final int completedInRange;

  /// Completed khatams, all time.
  final int totalAllTime;

  /// Completed khatams grouped by end year.
  final Map<int, int> byYear;

  /// Whether a khatam is currently in progress.
  final bool hasActiveKhatam;

  const KhatamReport({
    required this.range,
    required this.rangeLabel,
    required this.completedInRange,
    required this.totalAllTime,
    required this.byYear,
    required this.hasActiveKhatam,
  });
}

Future<TilawatReport> _tilawatReport(
  Ref ref,
  DateRange range,
  String label,
) async {
  final dao = ref.watch(tilawatDaoProvider);
  final unit = ref.watch(tilawatUnitProvider);
  final goal = ref.watch(tilawatGoalProvider);
  final totals = await dao.rangeTotals(range);
  final streak = await dao.streaks(
    todayYmd: DateUtilsExt.ymd(DateTime.now()),
  );
  return TilawatReport(
    range: range,
    rangeLabel: label,
    totals: totals,
    unit: unit,
    goal: goal,
    daysTotal: DateUtilsExt.parseYmd(range.endYmd)
            .difference(DateUtilsExt.parseYmd(range.startYmd))
            .inDays +
        1,
    goalAchievedDays: await dao.daysMeetingGoal(
      range,
      unit: unit,
      goal: goal,
    ),
    currentStreak: streak.current,
    bestStreak: streak.best,
  );
}

/// Tilawat day report.
final tilawatDayReportProvider =
    FutureProvider.family<TilawatReport, DateTime>((ref, day) {
      return _tilawatReport(ref, DateRange.dayOf(day),
          DateUtilsExt.pretty(day));
    });

/// Tilawat month report.
final tilawatMonthReportProvider =
    FutureProvider.family<TilawatReport, DateTime>((ref, month) {
      return _tilawatReport(
        ref,
        DateRange.monthOf(month),
        '${month.year}-${month.month.toString().padLeft(2, '0')}',
      );
    });

/// Tilawat year report.
final tilawatYearReportProvider =
    FutureProvider.family<TilawatReport, int>((ref, year) {
      return _tilawatReport(ref, DateRange.yearOf(DateTime(year)),
          '$year');
    });

/// Azkar report for an arbitrary range.
Future<AzkarReport> _azkarReport(Ref ref, DateRange range, String label) async {
  final dao = ref.watch(azkarDaoProvider);
  final stats = await ref.watch(azkarStatsProvider(range).future);
  final streak = await dao.streaks(
    todayYmd: DateUtilsExt.ymd(DateTime.now()),
    keys: dailyAzkarKeys,
  );
  return AzkarReport(
    range: range,
    rangeLabel: label,
    stats: stats,
    currentStreak: streak.current,
    bestStreak: streak.best,
  );
}

/// Azkar day report.
final azkarDayReportProvider =
    FutureProvider.family<AzkarReport, DateTime>((ref, day) {
      return _azkarReport(ref, DateRange.dayOf(day), DateUtilsExt.pretty(day));
    });

/// Azkar month report.
final azkarMonthReportProvider =
    FutureProvider.family<AzkarReport, DateTime>((ref, month) {
      return _azkarReport(
        ref,
        DateRange.monthOf(month),
        '${month.year}-${month.month.toString().padLeft(2, '0')}',
      );
    });

/// Azkar year report.
final azkarYearReportProvider =
    FutureProvider.family<AzkarReport, int>((ref, year) {
      return _azkarReport(ref, DateRange.yearOf(DateTime(year)), '$year');
    });

/// Khatam report for an arbitrary range.
Future<KhatamReport> _khatamReport(
  Ref ref,
  DateRange range,
  String label,
) async {
  final dao = ref.watch(khatamDaoProvider);
  final all = await dao.watchAll().first;
  final completed = all.where(
    (k) =>
        k.endDate != null &&
        k.endDate!.compareTo(range.startYmd) >= 0 &&
        k.endDate!.compareTo(range.endYmd) <= 0,
  );
  return KhatamReport(
    range: range,
    rangeLabel: label,
    completedInRange: completed.length,
    totalAllTime: all.where((k) => k.endDate != null).length,
    byYear: await dao.completedByYear(),
    hasActiveKhatam: all.any((k) => k.endDate == null),
  );
}

/// Khatam day report.
final khatamDayReportProvider =
    FutureProvider.family<KhatamReport, DateTime>((ref, day) {
      return _khatamReport(
        ref,
        DateRange.dayOf(day),
        DateUtilsExt.pretty(day),
      );
    });

/// Khatam month report.
final khatamMonthReportProvider =
    FutureProvider.family<KhatamReport, DateTime>((ref, month) {
      return _khatamReport(
        ref,
        DateRange.monthOf(month),
        '${month.year}-${month.month.toString().padLeft(2, '0')}',
      );
    });

/// Khatam year report.
final khatamYearReportProvider =
    FutureProvider.family<KhatamReport, int>((ref, year) {
      return _khatamReport(ref, DateRange.yearOf(DateTime(year)), '$year');
    });
