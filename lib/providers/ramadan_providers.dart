import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';

import '../db/app_database.dart';
import '../db/daos/ramadan_dao.dart';
import '../db/enums.dart';
import '../utils/date_utils_ext.dart';
import '../utils/streak_utils.dart';
import 'app_providers.dart';

// ── DAO ───────────────────────────────────────────────────────────────────

final ramadanDaoProvider = Provider<RamadanDao>((ref) {
  return ref.watch(dbProvider).ramadanDao;
});

// ── Hijri helpers ─────────────────────────────────────────────────────────

/// The current Hijri (Islamic) year — used to look up the active Ramadan.
int currentHijriYear() => HijriCalendar.fromDate(DateTime.now()).hYear;

/// Reads the Hijri y/m/d for a Gregorian [date].
({int year, int month, int day}) hijriOf(DateTime date) {
  final h = HijriCalendar.fromDate(date);
  return (year: h.hYear, month: h.hMonth, day: h.hDay);
}

/// The best-effort Gregorian date the 1st of Ramadan falls on for [hijriYear],
/// derived from the 9th Hijri month (Ramadan) of that year.
String ramadanStartDate(int hijriYear) {
  final greg = HijriCalendar().hijriToGregorian(hijriYear, 9, 1);
  return DateUtilsExt.ymd(greg);
}

// ── Seasons ───────────────────────────────────────────────────────────────

/// Live list of every Ramadan season, newest first.
final ramadanSeasonsProvider = StreamProvider<List<RamadanSeason>>((ref) {
  return ref.watch(ramadanDaoProvider).watchSeasons();
});

/// The active season (current Hijri year), auto-created if missing.
final ramadanActiveSeasonProvider = FutureProvider<RamadanSeason>((ref) async {
  final dao = ref.watch(ramadanDaoProvider);
  final year = currentHijriYear();
  return dao.ensureSeason(
    hijriYear: year,
    startDate: ramadanStartDate(year),
  );
});

/// Live 30-day rows for one season.
final ramadanDaysProvider =
    StreamProvider.family<List<RamadanDay>, int>((ref, seasonId) {
      return ref.watch(ramadanDaoProvider).watchDays(seasonId);
    });

/// Live season row for one season id (Sehri/Iftar, Itikaf, Zakat, …).
final ramadanSeasonProvider =
    StreamProvider.family<RamadanSeason?, int>((ref, seasonId) {
      return ref.watch(ramadanDaoProvider).watchSeason(seasonId);
    });

/// Totals for one season, recomputed whenever its day rows change.
final ramadanTotalsProvider =
    FutureProvider.family<RamadanTotals, int>((ref, seasonId) async {
      ref.watch(ramadanDaysProvider(seasonId));
      return ref.watch(ramadanDaoProvider).seasonTotals(seasonId);
    });

/// Fasting streak for the active season.
final ramadanStreakProvider = FutureProvider<StreakResult>((ref) async {
  final season = await ref.watch(ramadanActiveSeasonProvider.future);
  ref.watch(ramadanDaysProvider(season.id));
  return ref.watch(ramadanDaoProvider).streaks(
    seasonId: season.id,
    todayYmd: DateUtilsExt.ymd(DateTime.now()),
  );
});

// ── Aggregate dashboard stat ──────────────────────────────────────────────

/// Fast progress for the active season (done = fasted, total = 30 days).
final ramadanDashboardStatProvider = FutureProvider<({int done, int total})>((
  ref,
) async {
  final season = await ref.watch(ramadanActiveSeasonProvider.future);
  final totals = await ref.watch(ramadanTotalsProvider(season.id).future);
  return (done: totals.fasted, total: totals.totalDaysTarget);
});

/// Extension kept local so the dashboard provider can read the 30-day target.
extension RamadanTotalsX on RamadanTotals {
  int get totalDaysTarget => 30;
}

// ── Actions ───────────────────────────────────────────────────────────────

/// Thin action layer over RamadanDao so widgets never touch the DB directly.
class RamadanActions {
  final RamadanDao _dao;
  const RamadanActions(this._dao);

  Future<void> setDayStatus({
    required int seasonId,
    required int dayNumber,
    required RozaStatus status,
    RozaExcuse excuse = RozaExcuse.none,
  }) {
    return _dao.setDayStatus(
      seasonId: seasonId,
      dayNumber: dayNumber,
      status: status,
      excuse: excuse,
    );
  }

  Future<void> setTaraweeh({
    required int seasonId,
    required int dayNumber,
    required bool value,
  }) {
    return _dao.setTaraweeh(
      seasonId: seasonId,
      dayNumber: dayNumber,
      value: value,
    );
  }

  Future<void> setTahajjud({
    required int seasonId,
    required int dayNumber,
    required bool value,
  }) {
    return _dao.setTahajjud(
      seasonId: seasonId,
      dayNumber: dayNumber,
      value: value,
    );
  }

  Future<void> setQazaMadeUp({
    required int seasonId,
    required int dayNumber,
    required bool value,
  }) {
    return _dao.setQazaMadeUp(
      seasonId: seasonId,
      dayNumber: dayNumber,
      value: value,
    );
  }

  Future<void> setDayNote({
    required int seasonId,
    required int dayNumber,
    required String? note,
  }) {
    return _dao.setDayNote(
      seasonId: seasonId,
      dayNumber: dayNumber,
      note: note,
    );
  }

  Future<void> setMealTimes({
    required int seasonId,
    String? sehriTime,
    String? iftarTime,
  }) {
    return _dao.setMealTimes(
      seasonId: seasonId,
      sehriTime: sehriTime,
      iftarTime: iftarTime,
    );
  }

  Future<void> addZakat({
    required int seasonId,
    int? zakatDelta,
    int? sadaqahDelta,
  }) {
    return _dao.addZakat(
      seasonId: seasonId,
      zakatDelta: zakatDelta,
      sadaqahDelta: sadaqahDelta,
    );
  }

  Future<void> setItikaf({
    required int seasonId,
    required bool value,
  }) {
    return _dao.setItikaf(seasonId: seasonId, value: value);
  }

  Future<void> setLaylatulQadrNote({
    required int seasonId,
    required String? note,
  }) {
    return _dao.setLaylatulQadrNote(seasonId: seasonId, note: note);
  }

  Future<void> createSeason({
    required int hijriYear,
    required String startDate,
  }) {
    return _dao.createSeason(hijriYear: hijriYear, startDate: startDate);
  }
}

final ramadanActionsProvider = Provider<RamadanActions>((ref) {
  return RamadanActions(ref.watch(ramadanDaoProvider));
});
