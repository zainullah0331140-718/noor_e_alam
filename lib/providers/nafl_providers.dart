import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/app_database.dart';
import '../db/daos/nafl_dao.dart';
import '../db/enums.dart';
import '../utils/date_utils_ext.dart';
import 'app_providers.dart';

// ── DAO ───────────────────────────────────────────────────────────────────

final naflDaoProvider = Provider<NaflDao>((ref) {
  return ref.watch(dbProvider).naflDao;
});

// ── Day checklist ─────────────────────────────────────────────────────────

/// Live nafl rows for [date] (ymd). Includes "not done" rows so skipped
/// items stay visible.
final naflDayProvider =
    StreamProvider.family<List<NaflEntry>, String>((ref, date) {
      return ref.watch(naflDaoProvider).watchDay(date);
    });

/// Sum of rakats done on [date] — used by the progress ring & dashboard.
final naflDayRakatsProvider = Provider.family<AsyncValue<int>, String>((
  ref,
  date,
) {
  return ref
      .watch(naflDayProvider(date))
      .whenData((rows) => rows.where((r) => r.done).fold(0, (s, r) => s + r.rakats));
});

// ── Actions ───────────────────────────────────────────────────────────────

class NaflActions {
  final NaflDao _dao;
  const NaflActions(this._dao);

  Future<void> setFixed({
    required DateTime day,
    required NaflType type,
    required bool done,
    required int rakats,
    String? note,
  }) {
    return _dao.upsertFixed(
      date: DateUtilsExt.ymd(day),
      type: type,
      done: done,
      rakats: rakats,
      note: note,
    );
  }

  Future<void> setCustom({
    required DateTime day,
    required String name,
    required bool done,
    required int rakats,
    String? note,
  }) {
    return _dao.upsertCustom(
      date: DateUtilsExt.ymd(day),
      name: name,
      done: done,
      rakats: rakats,
      note: note,
    );
  }

  Future<void> deleteCustom({required DateTime day, required String name}) {
    return _dao.deleteCustom(date: DateUtilsExt.ymd(day), name: name);
  }
}

final naflActionsProvider = Provider<NaflActions>((ref) {
  return NaflActions(ref.watch(naflDaoProvider));
});

// ── Stats: day / month / year ─────────────────────────────────────────────

/// Per-day rakats from the month containing [month] — bar chart data.
final naflMonthRakatsProvider =
    FutureProvider.family<Map<String, int>, DateTime>((ref, month) {
      return ref
          .watch(naflDaoProvider)
          .rakatsByDay(DateRange.monthOf(month));
    });

/// 12 monthly rakats for [year].
final naflYearProvider = FutureProvider.family<List<int>, int>((ref, year) {
  return ref.watch(naflDaoProvider).rakatsByMonth(year);
});

/// Full nafl statistics bundle for the selected range.
final naflStatsProvider =
    FutureProvider.family<NaflStats, DateRange>((ref, range) async {
      final dao = ref.watch(naflDaoProvider);
      final totals = await dao.rangeTotals(range);
      final byType = await dao.rakatsByType(range);
      final days = await dao.daysPerformed(range);
      return NaflStats(
        rakats: totals.rakats,
        doneItems: totals.doneItems,
        byType: byType,
        daysPerformed: days,
      );
    });

/// Tahajjud & Duha streaks (separate counters).
final naflStreaksProvider = FutureProvider<NaflStreakPair>((ref) async {
  final dao = ref.watch(naflDaoProvider);
  final today = DateUtilsExt.ymd(DateTime.now());
  return NaflStreakPair(
    tahajjud: await dao.typeStreak(NaflType.tahajjud, todayYmd: today),
    duha: await dao.typeStreak(NaflType.chasht, todayYmd: today),
  );
});

/// Aggregate nafl statistics for a range.
class NaflStats {
  final int rakats;
  final int doneItems;
  final Map<NaflType, int> byType;
  final int daysPerformed;
  const NaflStats({
    required this.rakats,
    required this.doneItems,
    required this.byType,
    required this.daysPerformed,
  });

  static const empty = NaflStats(
    rakats: 0,
    doneItems: 0,
    byType: {},
    daysPerformed: 0,
  );
}

/// Tahajjud + Duha streak pair.
class NaflStreakPair {
  final int tahajjud;
  final int duha;
  const NaflStreakPair({required this.tahajjud, required this.duha});
}
