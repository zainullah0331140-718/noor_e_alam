import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/app_database.dart';
import '../db/daos/tilawat_dao.dart';
import '../db/enums.dart';
import '../utils/date_utils_ext.dart';
import '../utils/streak_utils.dart';
import 'app_providers.dart';

// ── DAO ───────────────────────────────────────────────────────────────────

final tilawatDaoProvider = Provider<TilawatDao>((ref) {
  return ref.watch(dbProvider).tilawatDao;
});

// ── Settings: logging unit + daily goal ──────────────────────────────────

/// Unit the user prefers when logging recitation (pages / ruku / para / min).
class TilawatUnitNotifier extends Notifier<TilawatUnit> {
  static const _key = 'tilawat_unit';

  @override
  TilawatUnit build() {
    final prefs = ref.watch(sharedPrefsProvider);
    final name = prefs.getString(_key);
    return TilawatUnit.values.firstWhere(
      (u) => u.name == name,
      orElse: () => TilawatUnit.pages,
    );
  }

  Future<void> set(TilawatUnit unit) async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setString(_key, unit.name);
    state = unit;
  }
}

final tilawatUnitProvider = NotifierProvider<TilawatUnitNotifier, TilawatUnit>(
  TilawatUnitNotifier.new,
);

/// Daily recitation goal (in the selected unit).
class TilawatGoalNotifier extends Notifier<int> {
  static const _key = 'tilawat_daily_goal';

  @override
  int build() {
    final prefs = ref.watch(sharedPrefsProvider);
    return prefs.getInt(_key) ?? 8;
  }

  Future<void> set(int goal) async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setInt(_key, goal < 1 ? 1 : goal);
    state = goal < 1 ? 1 : goal;
  }
}

final tilawatGoalProvider = NotifierProvider<TilawatGoalNotifier, int>(
  TilawatGoalNotifier.new,
);

// ── Day log ───────────────────────────────────────────────────────────────

/// Live recitation entries for one day (ymd).
final tilawatDayProvider =
    StreamProvider.family<List<TilawatEntry>, String>((ref, date) {
      return ref.watch(tilawatDaoProvider).watchDay(date);
    });

/// Saved reading position (para/surah/page), or null before first save.
final tilawatPositionProvider = FutureProvider<TilawatPosition?>((ref) {
  return ref.watch(tilawatDaoProvider).getPosition();
});

// ── Actions ───────────────────────────────────────────────────────────────

/// Thin action layer so widgets never touch the DB directly.
class TilawatActions {
  final TilawatDao _dao;
  const TilawatActions(this._dao);

  Future<void> addEntry({
    required DateTime day,
    required TilawatUnit unit,
    required int amount,
    String? note,
  }) {
    return _dao.addEntry(
      date: DateUtilsExt.ymd(day),
      unit: unit,
      amount: amount,
      note: note,
    );
  }

  Future<void> deleteEntry(int id) => _dao.deleteEntry(id);

  Future<void> savePosition({
    required int para,
    required String surah,
    required int page,
  }) {
    return _dao.savePosition(para: para, surah: surah, page: page);
  }
}

final tilawatActionsProvider = Provider<TilawatActions>((ref) {
  return TilawatActions(ref.watch(tilawatDaoProvider));
});

// ── Statistics ────────────────────────────────────────────────────────────

/// Aggregated Tilawat statistics for a date range.
class TilawatStats {
  final TilawatRangeTotals totals;
  final TilawatUnit unit;
  final int goal;
  final int daysTotal;
  final int goalAchievedDays;

  const TilawatStats({
    required this.totals,
    required this.unit,
    required this.goal,
    required this.daysTotal,
    required this.goalAchievedDays,
  });

  int get amount => totals.amountFor(unit);
  int get averagePerDay => totals.averagePerDay(unit);

  /// Fraction of elapsed days that met the daily goal (0..1).
  double get goalCompletion =>
      daysTotal == 0 ? 0 : goalAchievedDays / daysTotal;
}

/// Range-scoped Tilawat stats (used by the Day/Month/Year stats tabs).
final tilawatStatsProvider =
    FutureProvider.family<TilawatStats, DateRange>((ref, range) async {
      final dao = ref.watch(tilawatDaoProvider);
      final unit = ref.watch(tilawatUnitProvider);
      final goal = ref.watch(tilawatGoalProvider);
      final totals = await dao.rangeTotals(range);
      final achieved = await dao.daysMeetingGoal(
        range,
        unit: unit,
        goal: goal,
      );
      return TilawatStats(
        totals: totals,
        unit: unit,
        goal: goal,
        daysTotal: daysInRange(range.startYmd, range.endYmd),
        goalAchievedDays: achieved,
      );
    });

/// Per-day totals for the month containing [month] (heatmap source).
final tilawatMonthProvider =
    FutureProvider.family<Map<String, TilawatDayTotals>, DateTime>(
      (ref, month) =>
          ref.watch(tilawatDaoProvider).dayTotals(DateRange.monthOf(month)),
    );

/// Total pages recorded in each month of [year] (12-entry bar chart).
final tilawatYearProvider = FutureProvider.family<List<int>, int>((ref, year) {
  return ref.watch(tilawatDaoProvider).pagesByMonth(year);
});

/// Current + best recitation streak. Watches today's log so it refreshes
/// after every tap.
final tilawatStreakProvider = FutureProvider<StreakResult>((ref) async {
  final todayYmd = DateUtilsExt.ymd(DateTime.now());
  ref.watch(tilawatDayProvider(todayYmd));
  return ref.watch(tilawatDaoProvider).streaks(todayYmd: todayYmd);
});
