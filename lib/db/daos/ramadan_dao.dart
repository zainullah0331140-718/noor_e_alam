import 'package:drift/drift.dart';

import '../../utils/streak_utils.dart';
import '../app_database.dart';
import '../enums.dart';
import '../tables.dart';

part 'ramadan_dao.g.dart';

/// Aggregated fasting totals for one Ramadan season.
class RamadanTotals {
  final int fasted;
  final int missedExcused;
  final int missedNoExcuse;
  final int notRecorded;
  final int daysTotal;

  /// Taraweeh / Tahajjud nights counted across the season.
  final int taraweehNights;
  final int tahajjudNights;

  /// Missed fasts awaiting qaza (excused + unexcused, not yet made up).
  final int qazaPending;

  const RamadanTotals({
    this.fasted = 0,
    this.missedExcused = 0,
    this.missedNoExcuse = 0,
    this.notRecorded = 0,
    this.daysTotal = 30,
    this.taraweehNights = 0,
    this.tahajjudNights = 0,
    this.qazaPending = 0,
  });

  int get missed => missedExcused + missedNoExcuse;

  /// Share of logged days that were fasted (0..1).
  double get fastPercent => daysTotal == 0 ? 0 : fasted / daysTotal;
}

/// Data access for the Ramadan Hub module.
@DriftAccessor(tables: [RamadanSeasons, RamadanDays])
class RamadanDao extends DatabaseAccessor<AppDatabase>
    with _$RamadanDaoMixin {
  RamadanDao(super.db);

  // ── Seasons ─────────────────────────────────────────────────────────────

  /// Live list of every Ramadan season, newest first.
  Stream<List<RamadanSeason>> watchSeasons() {
    return (select(ramadanSeasons)
          ..orderBy([(t) => OrderingTerm.desc(t.hijriYear)]))
        .watch();
  }

  Future<List<RamadanSeason>> allSeasons() {
    return (select(ramadanSeasons)
          ..orderBy([(t) => OrderingTerm.desc(t.hijriYear)]))
        .get();
  }

  Future<RamadanSeason?> seasonByHijriYear(int hijriYear) {
    return (select(ramadanSeasons)
          ..where((t) => t.hijriYear.equals(hijriYear)))
        .getSingleOrNull();
  }

  /// Creates a season with 30 empty day rows and returns its id.
  Future<int> createSeason({
    required int hijriYear,
    required String startDate,
  }) async {
    final id = await into(ramadanSeasons).insert(
      RamadanSeasonsCompanion.insert(
        hijriYear: hijriYear,
        startDate: startDate,
      ),
    );
    for (var day = 1; day <= 30; day++) {
      await into(ramadanDays).insert(
        RamadanDaysCompanion.insert(seasonId: id, dayNumber: day),
      );
    }
    return id;
  }

  /// Returns the season for [hijriYear], creating it when missing.
  Future<RamadanSeason> ensureSeason({
    required int hijriYear,
    required String startDate,
  }) async {
    final existing = await seasonByHijriYear(hijriYear);
    if (existing != null) return existing;
    final id = await createSeason(
      hijriYear: hijriYear,
      startDate: startDate,
    );
    return (select(ramadanSeasons)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<int> deleteSeason(int id) {
    return (delete(ramadanSeasons)..where((t) => t.id.equals(id))).go();
  }

  Stream<RamadanSeason?> watchSeason(int id) {
    return (select(
      ramadanSeasons,
    )..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  // ── Day rows ────────────────────────────────────────────────────────────

  /// Live 30 day rows for one season, ordered by day number.
  Stream<List<RamadanDay>> watchDays(int seasonId) {
    return (select(ramadanDays)
          ..where((t) => t.seasonId.equals(seasonId))
          ..orderBy([(t) => OrderingTerm(expression: t.dayNumber)]))
        .watch();
  }

  Future<List<RamadanDay>> days(int seasonId) {
    return (select(ramadanDays)
          ..where((t) => t.seasonId.equals(seasonId))
          ..orderBy([(t) => OrderingTerm(expression: t.dayNumber)]))
        .get();
  }

  /// Updates one day's fasting status + shar'i excuse.
  Future<void> setDayStatus({
    required int seasonId,
    required int dayNumber,
    required RozaStatus status,
    RozaExcuse excuse = RozaExcuse.none,
  }) async {
    await (update(ramadanDays)..where(
          (t) => t.seasonId.equals(seasonId) & t.dayNumber.equals(dayNumber),
        ))
        .write(
          RamadanDaysCompanion(
            status: Value(status),
            excuse: Value(
              status == RozaStatus.missedExcused ? excuse : RozaExcuse.none,
            ),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  /// Toggles the Taraweeh flag for one night.
  Future<void> setTaraweeh({
    required int seasonId,
    required int dayNumber,
    required bool value,
  }) {
    return (update(ramadanDays)..where(
          (t) => t.seasonId.equals(seasonId) & t.dayNumber.equals(dayNumber),
        ))
        .write(
          RamadanDaysCompanion(
            taraweeh: Value(value),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  /// Toggles the Tahajjud flag for one night.
  Future<void> setTahajjud({
    required int seasonId,
    required int dayNumber,
    required bool value,
  }) {
    return (update(ramadanDays)..where(
          (t) => t.seasonId.equals(seasonId) & t.dayNumber.equals(dayNumber),
        ))
        .write(
          RamadanDaysCompanion(
            tahajjud: Value(value),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  /// Marks a missed fast's qaza as made up (or reverts it).
  Future<void> setQazaMadeUp({
    required int seasonId,
    required int dayNumber,
    required bool value,
  }) {
    return (update(ramadanDays)..where(
          (t) => t.seasonId.equals(seasonId) & t.dayNumber.equals(dayNumber),
        ))
        .write(
          RamadanDaysCompanion(
            qazaMadeUp: Value(value),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  Future<void> setDayNote({
    required int seasonId,
    required int dayNumber,
    required String? note,
  }) {
    return (update(ramadanDays)..where(
          (t) => t.seasonId.equals(seasonId) & t.dayNumber.equals(dayNumber),
        ))
        .write(
          RamadanDaysCompanion(
            note: Value(note),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  // ── Season-level fields ─────────────────────────────────────────────────

  /// Updates the Sehri / Iftar time overrides (any may be null).
  Future<void> setMealTimes({
    required int seasonId,
    String? sehriTime,
    String? iftarTime,
  }) {
    return (update(ramadanSeasons)..where((t) => t.id.equals(seasonId))).write(
      RamadanSeasonsCompanion(
        sehriTime: Value(sehriTime),
        iftarTime: Value(iftarTime),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Adds to the season's Zakat / Sadaqah totals (never below zero).
  Future<void> addZakat({
    required int seasonId,
    int? zakatDelta,
    int? sadaqahDelta,
  }) async {
    final season =
        await (select(ramadanSeasons)..where((t) => t.id.equals(seasonId)))
            .getSingle();
    final zakat = (season.zakatAmount + (zakatDelta ?? 0)).clamp(0, 1 << 62);
    final sadaqah =
        (season.sadaqahAmount + (sadaqahDelta ?? 0)).clamp(0, 1 << 62);
    await (update(ramadanSeasons)..where((t) => t.id.equals(seasonId))).write(
      RamadanSeasonsCompanion(
        zakatAmount: Value(zakat),
        sadaqahAmount: Value(sadaqah),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> setItikaf({
    required int seasonId,
    required bool value,
  }) {
    return (update(ramadanSeasons)..where((t) => t.id.equals(seasonId))).write(
      RamadanSeasonsCompanion(
        itikafDone: Value(value),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> setLaylatulQadrNote({
    required int seasonId,
    required String? note,
  }) {
    return (update(ramadanSeasons)..where((t) => t.id.equals(seasonId))).write(
      RamadanSeasonsCompanion(
        laylatulQadrNote: Value(note),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // ── Aggregates ──────────────────────────────────────────────────────────

  /// Totals for one season (counts + qaza pending).
  Future<RamadanTotals> seasonTotals(int seasonId) async {
    final rows = await days(seasonId);
    var fasted = 0;
    var excused = 0;
    var noExcuse = 0;
    var taraweeh = 0;
    var tahajjud = 0;
    var qazaPending = 0;
    for (final row in rows) {
      switch (row.status) {
        case RozaStatus.fasted:
          fasted++;
        case RozaStatus.missedExcused:
          excused++;
          if (!row.qazaMadeUp) qazaPending++;
        case RozaStatus.missedNoExcuse:
          noExcuse++;
          if (!row.qazaMadeUp) qazaPending++;
        case RozaStatus.notRecorded:
          break;
      }
      if (row.taraweeh) taraweeh++;
      if (row.tahajjud) tahajjud++;
    }
    return RamadanTotals(
      fasted: fasted,
      missedExcused: excused,
      missedNoExcuse: noExcuse,
      notRecorded: rows.where((r) => r.status == RozaStatus.notRecorded).length,
      daysTotal: rows.isEmpty ? 30 : rows.length,
      taraweehNights: taraweeh,
      tahajjudNights: tahajjud,
      qazaPending: qazaPending,
    );
  }

  /// How many fasts have been completed since [todayYmd] (for streaks).
  Future<StreakResult> streaks({
    required int seasonId,
    required String todayYmd,
  }) async {
    final rows = await days(seasonId);
    final fastedDays = <String>{};
    for (final row in rows) {
      if (row.status == RozaStatus.fasted && row.date != null) {
        fastedDays.add(row.date!);
      }
    }
    return computeStreak(completedDays: fastedDays, todayYmd: todayYmd);
  }

  /// Fast/qaza breakdown per Hijri year (for the yearly log chart).
  Future<Map<int, RamadanTotals>> totalsByYear() async {
    final seasons = await allSeasons();
    final map = <int, RamadanTotals>{};
    for (final season in seasons) {
      map[season.hijriYear] = await seasonTotals(season.id);
    }
    return map;
  }
}
