import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/enums.dart';
import '../utils/date_utils_ext.dart';
import 'app_providers.dart';
import 'azkar_providers.dart';
import 'gheebat_providers.dart';
import 'khatam_providers.dart';
import 'muraqaba_providers.dart';
import 'nafl_providers.dart';
import 'namaz_providers.dart';
import 'ramadan_providers.dart';
import 'settings_providers.dart';
import 'tilawat_providers.dart';

/// Default per-day muraqaba target used by the dashboard completion ring.
const int _muraqabaDailyGoalMinutes = 10;

/// A single dashboard donut card's value set.
class DashboardStat {
  final int done;
  final int total;
  final int jamaat;
  final int alone;
  final int missed;

  const DashboardStat({
    required this.done,
    required this.total,
    this.jamaat = 0,
    this.alone = 0,
    this.missed = 0,
  });

  double get completion => total == 0 ? 0 : done / total;
}

/// Aggregated dashboard data for the currently selected range
/// (Today / Month / Year from dashboardRangeProvider).
class DashboardData {
  final DashboardRange range;
  final DashboardStat prayers;
  final DashboardStat nafl;
  final DashboardStat tilawat;
  final DashboardStat azkar;
  final DashboardStat khatam;
  final DashboardStat gheebat;
  final DashboardStat muraqaba;
  final DashboardStat ramadan;
  final int currentStreak;
  final int bestStreak;

  /// Day rakats for the nafl progress ring (always "today").
  final int naflTodayRakats;

  const DashboardData({
    required this.range,
    required this.prayers,
    required this.nafl,
    required this.tilawat,
    required this.azkar,
    required this.khatam,
    required this.gheebat,
    required this.muraqaba,
    required this.ramadan,
    required this.currentStreak,
    required this.bestStreak,
    required this.naflTodayRakats,
  });
}

/// The dashboard's single source of truth. Rebuilds when the range toggle
/// changes, when today's namaz rows change, and when the DB seed finishes.
final dashboardProvider = FutureProvider<DashboardData>((ref) async {
  final range = ref.watch(dashboardRangeProvider);
  final namazDao = ref.watch(namazDaoProvider);
  final naflDao = ref.watch(naflDaoProvider);
  final now = DateTime.now();
  final todayYmd = DateUtilsExt.ymd(now);

  // Re-derive the DB range from the toggle.
  final DateRange dbRange = switch (range) {
    DashboardRange.today => DateRange.dayOf(now),
    DashboardRange.month => DateRange.monthOf(now),
    DashboardRange.year => DateRange.yearOf(now),
  };

  // Namaz totals + streaks.
  final namazCounts = await namazDao.rangeCounts(dbRange);
  final streak = await namazDao.streaks(todayYmd: todayYmd);

  // Nafl totals for the range + today's rakats for the ring.
  final naflTotals = await naflDao.rangeTotals(dbRange);
  final naflToday = await naflDao.rangeTotals(DateRange.dayOf(now));

  // Expected prayer count = range days × 6 prayers (Fajr..Witr).
  // "done" counts jamaat + alone (i.e. prayed), total includes misses.
  final expectedPrayers = namazCounts.total == 0
      ? _expectedTotal(range, now)
      : namazCounts.total;
  final namazStat = DashboardStat(
    done: namazCounts.prayed,
    total: expectedPrayers,
    jamaat: namazCounts.jamaat,
    alone: namazCounts.alone,
    missed: namazCounts.missed,
  );

  // Nafl card: done rakats measured against a rolling "goal × days" target.
  final goal = ref.watch(naflGoalProvider);
  final rangeDays = dbRange.endYmd == dbRange.startYmd
      ? 1
      : DateUtilsExt.parseYmd(
              dbRange.endYmd,
            ).difference(DateUtilsExt.parseYmd(dbRange.startYmd)).inDays +
            1;
  final naflTarget = (rangeDays.clamp(1, 31)) * goal;
  final naflStat = DashboardStat(
    done: naflTotals.rakats,
    total: naflTotals.rakats > naflTarget ? naflTotals.rakats : naflTarget,
  );

  // Tilawat: amount in the preferred unit against goal × days.
  final tilawatTotals = await ref
      .watch(tilawatDaoProvider)
      .rangeTotals(dbRange);
  final tilawatUnit = ref.watch(tilawatUnitProvider);
  final tilawatGoal = ref.watch(tilawatGoalProvider);
  final tilawatDone = tilawatTotals.amountFor(tilawatUnit);
  final tilawatTarget = rangeDays * tilawatGoal;
  final tilawatStat = DashboardStat(
    done: tilawatDone,
    total: tilawatDone > tilawatTarget ? tilawatDone : tilawatTarget,
  );

  // Azkar: clamped done counts against expected counts for the range.
  final azkarStats = await ref.watch(azkarStatsProvider(dbRange).future);
  final azkarStat = DashboardStat(
    done: azkarStats.clampedDone,
    total: azkarStats.expectedTotal,
  );

  // Khatam: completions inside the range; the year view compares against
  // the user's yearly goal.
  final allKhatams = await ref.watch(khatamDaoProvider).watchAll().first;
  final completedInRange = allKhatams.where((k) {
    final end = k.endDate;
    return end != null &&
        end.compareTo(dbRange.startYmd) >= 0 &&
        end.compareTo(dbRange.endYmd) <= 0;
  }).length;
  final khatamGoal = ref.watch(khatamGoalProvider);
  final isYear = range == DashboardRange.year;
  final khatamStat = DashboardStat(
    done: completedInRange,
    total: isYear
        ? (khatamGoal > completedInRange ? khatamGoal : completedInRange)
        : (completedInRange == 0 ? 1 : completedInRange),
  );

  // Gheebat: free days versus the days actually checked in.
  final gheebatTotals = await ref
      .watch(gheebatDaoProvider)
      .rangeTotals(dbRange);
  final gheebatStat = DashboardStat(
    done: gheebatTotals.free,
    total: gheebatTotals.recorded,
  );

  // Muraqaba: minutes practised against a gentle daily target.
  final muraqabaTotals = await ref
      .watch(muraqabaDaoProvider)
      .rangeTotals(dbRange);
  final muraqabaTarget = rangeDays * _muraqabaDailyGoalMinutes;
  final muraqabaStat = DashboardStat(
    done: muraqabaTotals.minutes,
    total: muraqabaTotals.minutes > muraqabaTarget
        ? muraqabaTotals.minutes
        : muraqabaTarget,
  );

  // Ramadan: fasts completed in the active season (30-day target).
  final ramadanTotals = await ref.watch(ramadanDashboardStatProvider.future);
  final ramadanStat = DashboardStat(
    done: ramadanTotals.done,
    total: ramadanTotals.total,
  );

  return DashboardData(
    range: range,
    prayers: namazStat,
    nafl: naflStat,
    tilawat: tilawatStat,
    azkar: azkarStat,
    khatam: khatamStat,
    gheebat: gheebatStat,
    muraqaba: muraqabaStat,
    ramadan: ramadanStat,
    currentStreak: streak.current,
    bestStreak: streak.best,
    naflTodayRakats: naflToday.rakats,
  );
});

/// Expected number of prayer slots for a range (days × 6).
int _expectedTotal(DashboardRange range, DateTime now) {
  switch (range) {
    case DashboardRange.today:
      return NamazType.values.length; // 6
    case DashboardRange.month:
      final days = DateUtilsExt.parseYmd(DateRange.monthOf(now).endYmd).day;
      return days * NamazType.values.length;
    case DashboardRange.year:
      return 365 * NamazType.values.length;
  }
}
