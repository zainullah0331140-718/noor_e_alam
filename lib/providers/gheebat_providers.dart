import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/app_database.dart';
import '../db/daos/gheebat_dao.dart';
import '../db/enums.dart';
import '../utils/date_utils_ext.dart';
import '../utils/streak_utils.dart';
import 'app_providers.dart';

// ── DAO ───────────────────────────────────────────────────────────────────

final gheebatDaoProvider = Provider<GheebatDao>((ref) {
  return ref.watch(dbProvider).gheebatDao;
});

// ── Day ───────────────────────────────────────────────────────────────────

/// Live Gheebat check-in for one day (ymd).
final gheebatDayProvider =
    StreamProvider.family<GheebatEntry?, String>((ref, date) {
      return ref.watch(gheebatDaoProvider).watchDay(date);
    });

/// Recorded status per `yyyy-MM-dd` for the month containing [month].
final gheebatMonthStatusProvider =
    FutureProvider.family<Map<String, GheebatStatus>, DateTime>((ref, month) {
      return ref
          .watch(gheebatDaoProvider)
          .statusByDay(DateRange.monthOf(month));
    });

// ── Actions ───────────────────────────────────────────────────────────────

class GheebatActions {
  final GheebatDao _dao;
  const GheebatActions(this._dao);

  Future<void> setStatus(DateTime day, GheebatStatus status) {
    return _dao.setStatus(date: DateUtilsExt.ymd(day), status: status);
  }

  Future<void> setNote(DateTime day, String note) {
    return _dao.setNote(date: DateUtilsExt.ymd(day), note: note);
  }

  Future<void> addIstighfar(DateTime day, {int delta = 1}) {
    return _dao.incrementIstighfar(DateUtilsExt.ymd(day), delta: delta);
  }

  Future<void> reset(DateTime day) {
    return _dao.resetDay(DateUtilsExt.ymd(day));
  }
}

final gheebatActionsProvider = Provider<GheebatActions>((ref) {
  return GheebatActions(ref.watch(gheebatDaoProvider));
});

// ── Statistics ────────────────────────────────────────────────────────────

/// Aggregated Gheebat statistics for a date range.
class GheebatStats {
  final GheebatRangeTotals totals;
  final int daysTotal;

  const GheebatStats({required this.totals, required this.daysTotal});

  double get freePercent => totals.freePercent;
  int get free => totals.free;
  int get slipped => totals.slipped;
  int get recorded => totals.recorded;
}

final gheebatStatsProvider =
    FutureProvider.family<GheebatStats, DateRange>((ref, range) async {
      final totals = await ref.watch(gheebatDaoProvider).rangeTotals(range);
      return GheebatStats(
        totals: totals,
        daysTotal: daysInRange(range.startYmd, range.endYmd),
      );
    });

/// Free-day counts for each month of [year] (12-entry bar chart).
final gheebatYearProvider = FutureProvider.family<List<int>, int>((ref, year) {
  return ref.watch(gheebatDaoProvider).freeByMonth(year);
});

/// Current + best gheebat-free streak. Watches today's row to auto-refresh.
final gheebatStreakProvider = FutureProvider<StreakResult>((ref) async {
  final todayYmd = DateUtilsExt.ymd(DateTime.now());
  ref.watch(gheebatDayProvider(todayYmd));
  return ref.watch(gheebatDaoProvider).streaks(todayYmd: todayYmd);
});
