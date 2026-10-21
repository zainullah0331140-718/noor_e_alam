import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/app_database.dart';
import '../db/daos/namaz_dao.dart';
import '../db/enums.dart';
import '../utils/date_utils_ext.dart';
import 'app_providers.dart';

// ── DAO ───────────────────────────────────────────────────────────────────

final namazDaoProvider = Provider<NamazDao>((ref) {
  return ref.watch(dbProvider).namazDao;
});

// ── Day rows ──────────────────────────────────────────────────────────────

/// All six prayer rows for [date], normalised so every NamazType is present
/// (missing DB rows surface as NamazStatus.none). Keyed by ymd string.
final namazDayProvider =
    StreamProvider.family<Map<NamazType, NamazEntry>, String>((ref, date) {
      return ref.watch(namazDaoProvider).watchDay(date).map((rows) {
        final map = <NamazType, NamazEntry>{};
        for (final r in rows) {
          map[r.prayer] = r;
        }
        return map;
      });
    });

/// Convenience: the day rows as counts (jamaat/alone/missed/none).
final namazDayCountsProvider =
    Provider.family<AsyncValue<NamazRangeCounts>, String>((ref, date) {
      return ref.watch(namazDayProvider(date)).whenData((rows) {
        var jamaat = 0, alone = 0, missed = 0, none = 0;
        for (final p in NamazType.values) {
          switch (rows[p]?.status ?? NamazStatus.none) {
            case NamazStatus.jamaat:
              jamaat++;
            case NamazStatus.alone:
              alone++;
            case NamazStatus.missed:
              missed++;
            case NamazStatus.none:
              none++;
          }
        }
        return NamazRangeCounts(
          jamaat: jamaat,
          alone: alone,
          missed: missed,
          none: none,
        );
      });
    });

// ── Actions ───────────────────────────────────────────────────────────────

/// Thin action layer over NamazDao so widgets never touch the DB directly.
class NamazActions {
  final NamazDao _dao;
  const NamazActions(this._dao);

  Future<void> setStatus({
    required DateTime day,
    required NamazType prayer,
    required NamazStatus status,
    bool takbeerUla = false,
    bool masbooq = false,
    bool atMasjid = false,
  }) {
    return _dao.upsertStatus(
      date: DateUtilsExt.ymd(day),
      prayer: prayer,
      status: status,
      takbeerUla: takbeerUla,
      masbooq: masbooq,
      atMasjid: atMasjid,
    );
  }

  Future<void> setFlags({
    required DateTime day,
    required NamazType prayer,
    required bool takbeerUla,
    required bool masbooq,
    required bool atMasjid,
  }) {
    return _dao.updateFlags(
      date: DateUtilsExt.ymd(day),
      prayer: prayer,
      takbeerUla: takbeerUla,
      masbooq: masbooq,
      atMasjid: atMasjid,
    );
  }
}

final namazActionsProvider = Provider<NamazActions>((ref) {
  return NamazActions(ref.watch(namazDaoProvider));
});

// ── History: month / year ─────────────────────────────────────────────────

/// Per-day J/A/M tallies for the month containing [month].
final namazMonthProvider =
    FutureProvider.family<Map<String, NamazRangeCounts>, DateTime>(
      (ref, month) => ref
          .watch(namazDaoProvider)
          .countsByDay(DateRange.monthOf(month)),
    );

/// 12 monthly tallies for [year] (index 0 = January).
final namazYearProvider =
    FutureProvider.family<List<NamazRangeCounts>, int>((ref, year) {
      return ref.watch(namazDaoProvider).monthTotals(year);
    });

/// Total + per-prayer missed counts over the month containing [month].
final namazMonthAnalysisProvider =
    FutureProvider.family<NamazAnalysis, DateTime>((ref, month) async {
      final dao = ref.watch(namazDaoProvider);
      final range = DateRange.monthOf(month);
      final totals = await dao.rangeCounts(range);
      final byPrayer = await dao.missedByPrayer(range);
      return NamazAnalysis(totals: totals, missedByPrayer: byPrayer);
    });

/// Per-prayer missed counts over the year containing [year].
final namazYearAnalysisProvider =
    FutureProvider.family<NamazAnalysis, int>((ref, year) async {
      final dao = ref.watch(namazDaoProvider);
      final range = DateRange.yearOf(DateTime(year));
      final totals = await dao.rangeCounts(range);
      final byPrayer = await dao.missedByPrayer(range);
      return NamazAnalysis(totals: totals, missedByPrayer: byPrayer);
    });

/// Current + best fard-completion streak (recomputed when any namaz row
/// changes via the invalidation in NamazActions' call sites).
final namazStreakProvider = FutureProvider<StreakPair>((ref) {
  // Watch today's rows so the streak refreshes as the user marks prayers.
  ref.watch(namazDayProvider(DateUtilsExt.ymd(DateTime.now())));
  return ref
      .watch(namazDaoProvider)
      .streaks(todayYmd: DateUtilsExt.ymd(DateTime.now()));
});

/// Aggregate analysis result for one range.
class NamazAnalysis {
  final NamazRangeCounts totals;
  final Map<NamazType, int> missedByPrayer;
  const NamazAnalysis({required this.totals, required this.missedByPrayer});

  /// The prayer with the highest missed count (null when none missed).
  NamazType? get mostMissed {
    var best = 0;
    NamazType? type;
    missedByPrayer.forEach((k, v) {
      if (v > best) {
        best = v;
        type = k;
      }
    });
    return best == 0 ? null : type;
  }
}
