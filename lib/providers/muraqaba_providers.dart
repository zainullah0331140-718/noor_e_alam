import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/app_database.dart';
import '../db/daos/muraqaba_dao.dart';
import '../db/enums.dart';
import '../utils/date_utils_ext.dart';
import '../utils/streak_utils.dart';
import 'app_providers.dart';

// ── DAO ───────────────────────────────────────────────────────────────────

final muraqabaDaoProvider = Provider<MuraqabaDao>((ref) {
  return ref.watch(dbProvider).muraqabaDao;
});

// ── Day ───────────────────────────────────────────────────────────────────

/// Live sessions for one day (ymd).
final muraqabaDayProvider =
    StreamProvider.family<List<MuraqabaSession>, String>((ref, date) {
      return ref.watch(muraqabaDaoProvider).watchDay(date);
    });

/// Minutes practised per day inside [range] (heatmap / dashboard).
final muraqabaMinutesByDayProvider =
    FutureProvider.family<Map<String, int>, DateRange>((ref, range) {
      return ref.watch(muraqabaDaoProvider).minutesByDay(range);
    });

// ── Actions ───────────────────────────────────────────────────────────────

class MuraqabaActions {
  final MuraqabaDao _dao;
  const MuraqabaActions(this._dao);

  Future<int> addSession({
    required DateTime day,
    required int minutes,
    MuraqabaTime timeOfDay = MuraqabaTime.afterFajr,
    String? note,
    String source = 'manual',
  }) {
    return _dao.addSession(
      date: DateUtilsExt.ymd(day),
      minutes: minutes,
      timeOfDay: timeOfDay,
      note: note,
      source: source,
    );
  }

  Future<void> deleteSession(int id) => _dao.deleteSession(id);

  Future<void> deleteDay(DateTime day) {
    return _dao.deleteDay(DateUtilsExt.ymd(day));
  }
}

final muraqabaActionsProvider = Provider<MuraqabaActions>((ref) {
  return MuraqabaActions(ref.watch(muraqabaDaoProvider));
});

// ── Statistics ────────────────────────────────────────────────────────────

/// Aggregated Muraqaba statistics for a date range.
class MuraqabaStats {
  final MuraqabaRangeTotals totals;
  final int daysTotal;

  const MuraqabaStats({required this.totals, required this.daysTotal});

  int get minutes => totals.minutes;
  int get sessions => totals.sessions;
  int get days => totals.days;

  /// Fraction of days with at least one session (0..1).
  double get consistency => daysTotal == 0 ? 0 : days / daysTotal;
}

final muraqabaStatsProvider =
    FutureProvider.family<MuraqabaStats, DateRange>((ref, range) async {
      final totals = await ref.watch(muraqabaDaoProvider).rangeTotals(range);
      return MuraqabaStats(
        totals: totals,
        daysTotal: daysInRange(range.startYmd, range.endYmd),
      );
    });

/// Minutes practised in each month of [year] (12-entry bar chart).
final muraqabaYearProvider = FutureProvider.family<List<int>, int>((
  ref,
  year,
) {
  return ref.watch(muraqabaDaoProvider).minutesByMonth(year);
});

/// Current + best practice streak. Watches today's sessions to auto-refresh.
final muraqabaStreakProvider = FutureProvider<StreakResult>((ref) async {
  final todayYmd = DateUtilsExt.ymd(DateTime.now());
  ref.watch(muraqabaDayProvider(todayYmd));
  return ref.watch(muraqabaDaoProvider).streaks(todayYmd: todayYmd);
});
