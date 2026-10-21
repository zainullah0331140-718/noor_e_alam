import 'package:drift/drift.dart';

import '../../utils/date_utils_ext.dart' show DateRange;
import '../app_database.dart';
import '../enums.dart';
import '../tables.dart';

part 'namaz_dao.g.dart';

/// Data access for the daily five-prayer (+Witr) tracker.
///
/// All writes go through [upsertStatus] so the UI can fire-and-forget on
/// every tap; missed prayers are mirrored into the qaza ledger atomically.
@DriftAccessor(tables: [NamazEntries, QazaRecords])
class NamazDao extends DatabaseAccessor<AppDatabase> with _$NamazDaoMixin {
  NamazDao(super.db);

  // ── Day tracking ────────────────────────────────────────────────────────

  /// Live stream of all six prayer rows for one day (missing rows mean
  /// "not marked yet"; UI converts them to NamazStatus.none).
  Stream<List<NamazEntry>> watchDay(String date) {
    return (select(namazEntries)..where((t) => t.date.equals(date)))
        .watch();
  }

  Future<List<NamazEntry>> getDay(String date) {
    return (select(namazEntries)..where((t) => t.date.equals(date))).get();
  }

  /// Insert-or-update one prayer. Automatically adds/removes the matching
  /// auto-qaza row when the status flips to/from missed.
  Future<void> upsertStatus({
    required String date,
    required NamazType prayer,
    required NamazStatus status,
    bool takbeerUla = false,
    bool masbooq = false,
    bool atMasjid = false,
  }) {
    return transaction(() async {
      await into(namazEntries).insertOnConflictUpdate(
        NamazEntriesCompanion(
          date: Value(date),
          prayer: Value(prayer),
          status: Value(status),
          takbeerUla: Value(takbeerUla),
          masbooq: Value(masbooq),
          atMasjid: Value(atMasjid),
          updatedAt: Value(DateTime.now()),
        ),
      );
      // Mirror into the qaza ledger.
      if (status == NamazStatus.missed) {
        final exists =
            await (select(qazaRecords)
                  ..where(
                    (q) =>
                        q.prayer.equals(prayer.index) &
                        q.logDate.equals(date) &
                        q.source.equals('auto'),
                  ))
                .getSingleOrNull();
        if (exists == null) {
          await into(qazaRecords).insert(
            QazaRecordsCompanion.insert(
              prayer: prayer,
              logDate: date,
              source: const Value('auto'),
            ),
          );
        }
      } else {
        // Prayed after all → the pending auto-qaza for that day is void.
        await (delete(qazaRecords)
              ..where(
                (q) =>
                    q.prayer.equals(prayer.index) &
                    q.logDate.equals(date) &
                    q.source.equals('auto') &
                    q.isMadeUp.equals(false),
              ))
            .go();
      }
    });
  }

  /// Update only the optional flags (toggles under the segmented control).
  Future<void> updateFlags({
    required String date,
    required NamazType prayer,
    required bool takbeerUla,
    required bool masbooq,
    required bool atMasjid,
  }) {
    return (update(namazEntries)
          ..where((t) => t.date.equals(date) & t.prayer.equals(prayer.index)))
        .write(
      NamazEntriesCompanion(
        takbeerUla: Value(takbeerUla),
        masbooq: Value(masbooq),
        atMasjid: Value(atMasjid),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // ── Aggregation for stats & dashboard ───────────────────────────────────

  /// J/A/M counts over an inclusive ymd range (string compare = date compare).
  Future<NamazRangeCounts> rangeCounts(DateRange range) async {
    final rows = await (select(namazEntries)
          ..where(
            (t) => t.date.isBiggerOrEqualValue(range.startYmd) &
                t.date.isSmallerOrEqualValue(range.endYmd),
          ))
        .get();
    return _tally(rows);
  }

  /// Same as [rangeCounts] but grouped per day — powers the heatmap.
  Future<Map<String, NamazRangeCounts>> countsByDay(DateRange range) async {
    final rows = await (select(namazEntries)
          ..where(
            (t) => t.date.isBiggerOrEqualValue(range.startYmd) &
                t.date.isSmallerOrEqualValue(range.endYmd),
          ))
        .get();
    final map = <String, List<NamazEntry>>{};
    for (final r in rows) {
      (map[r.date] ??= []).add(r);
    }
    return map.map((d, list) => MapEntry(d, _tally(list)));
  }

  /// Per-prayer missed counts over a range — "which prayer is missed most".
  Future<Map<NamazType, int>> missedByPrayer(DateRange range) async {
    final rows = await (select(namazEntries)
          ..where(
            (t) => t.date.isBiggerOrEqualValue(range.startYmd) &
                t.date.isSmallerOrEqualValue(range.endYmd) &
                t.status.equals(NamazStatus.missed.index),
          ))
        .get();
    final map = {for (final p in NamazType.values) p: 0};
    for (final r in rows) {
      map[r.prayer] = (map[r.prayer] ?? 0) + 1;
    }
    return map;
  }

  /// Month totals for the year bar chart: 12 buckets of J/A/M.
  Future<List<NamazRangeCounts>> monthTotals(int year) async {
    final rows =
        await (select(namazEntries)
              ..where((t) => t.date.like('$year-%')))
            .get();
    final buckets = List.generate(12, (_) => <NamazEntry>[]);
    for (final r in rows) {
      final month = int.tryParse(r.date.substring(5, 7));
      if (month != null && month >= 1 && month <= 12) {
        buckets[month - 1].add(r);
      }
    }
    return buckets.map(_tally).toList();
  }

  // ── Streaks ─────────────────────────────────────────────────────────────

  /// Current + best streak of days where all 5 fard prayers are prayed
  /// (jamaat or alone). Walks backwards from [todayYmd]; a day with zero
  /// rows counts as broken (today is skipped if it has no rows yet, so the
  /// streak isn't lost before Fajr).
  Future<StreakPair> streaks({required String todayYmd}) async {
    final rows =
        await (select(namazEntries)
              ..where((t) => t.status.isNotInValues([
                NamazStatus.none,
                NamazStatus.missed,
              ])))
            .get();
    final prayedByDay = <String, Set<NamazType>>{};
    for (final r in rows) {
      prayedByDay.putIfAbsent(r.date, () => {}).add(r.prayer);
    }
    // Walk back day by day from today.
    var current = 0;
    var day = _parse(todayYmd);
    // If today isn't complete yet, start counting from yesterday.
    final todayDone = _isFardComplete(prayedByDay[todayYmd]);
    if (!todayDone) day = day.subtract(const Duration(days: 1));
    while (_isFardComplete(prayedByDay[_ymd(day)])) {
      current++;
      day = day.subtract(const Duration(days: 1));
    }
    // Best streak: scan all days that have any data, sorted.
    var best = 0;
    var run = 0;
    String? prev;
    final days = prayedByDay.keys.toList()..sort();
    for (final d in days) {
      if (!_isFardComplete(prayedByDay[d])) {
        run = 0;
      } else {
        if (prev != null && _consecutive(prev, d)) {
          run++;
        } else {
          run = 1;
        }
        if (run > best) best = run;
      }
      prev = d;
    }
    return StreakPair(current: current, best: best);
  }

  // ── helpers ─────────────────────────────────────────────────────────────

  static bool _isFardComplete(Set<NamazType>? day) {
    if (day == null) return false;
    return NamazType.fard.every(day.contains);
  }

  static bool _consecutive(String a, String b) {
    return _parse(b).difference(_parse(a)).inDays == 1;
  }

  static DateTime _parse(String ymd) =>
      DateTime(int.parse(ymd.substring(0, 4)), int.parse(ymd.substring(5, 7)),
          int.parse(ymd.substring(8, 10)));

  static String _ymd(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static NamazRangeCounts _tally(List<NamazEntry> rows) {
    var jamaat = 0, alone = 0, missed = 0, none = 0;
    for (final r in rows) {
      switch (r.status) {
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
  }
}

/// Immutable J/A/M tally over a day, month or year.
class NamazRangeCounts {
  final int jamaat;
  final int alone;
  final int missed;
  final int none;

  const NamazRangeCounts({
    required this.jamaat,
    required this.alone,
    required this.missed,
    required this.none,
  });

  int get prayed => jamaat + alone;
  int get total => jamaat + alone + missed + none;
  double get jamaatPercent => prayed == 0 ? 0 : jamaat / prayed * 100;

  static const empty = NamazRangeCounts(
    jamaat: 0,
    alone: 0,
    missed: 0,
    none: 0,
  );
}

/// Current + best consecutive-day streak.
class StreakPair {
  final int current;
  final int best;
  const StreakPair({required this.current, required this.best});
}
