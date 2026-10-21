import 'package:drift/drift.dart';

import '../../utils/date_utils_ext.dart';
import '../../utils/streak_utils.dart';
import '../app_database.dart';
import '../enums.dart';
import '../tables.dart';

part 'muraqaba_dao.g.dart';

/// Aggregated Muraqaba totals for an inclusive range.
class MuraqabaRangeTotals {
  final int minutes;
  final int sessions;
  final int days;

  const MuraqabaRangeTotals({
    this.minutes = 0,
    this.sessions = 0,
    this.days = 0,
  });

  /// Average session length in minutes (rounded).
  int get averageMinutes => sessions == 0 ? 0 : (minutes / sessions).round();
}

/// Data access for the Muraqaba (meditation) module.
@DriftAccessor(tables: [MuraqabaSessions])
class MuraqabaDao extends DatabaseAccessor<AppDatabase>
    with _$MuraqabaDaoMixin {
  MuraqabaDao(super.db);

  // ── Sessions ────────────────────────────────────────────────────────────

  /// Live sessions for one day, oldest first.
  Stream<List<MuraqabaSession>> watchDay(String date) {
    return (select(muraqabaSessions)
          ..where((t) => t.date.equals(date))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
        .watch();
  }

  /// All sessions inside [range] (report source).
  Future<List<MuraqabaSession>> sessionsInRange(DateRange range) {
    return (select(muraqabaSessions)
          ..where(
            (t) =>
                t.date.isBiggerOrEqualValue(range.startYmd) &
                t.date.isSmallerOrEqualValue(range.endYmd),
          )
          ..orderBy([(t) => OrderingTerm(expression: t.date)]))
        .get();
  }

  /// Adds one completed session.
  Future<int> addSession({
    required String date,
    required int minutes,
    MuraqabaTime timeOfDay = MuraqabaTime.afterFajr,
    String? note,
    String source = 'manual',
  }) {
    return into(muraqabaSessions).insert(
      MuraqabaSessionsCompanion.insert(
        date: date,
        minutes: Value(minutes < 1 ? 1 : minutes),
        timeOfDay: Value(timeOfDay),
        note: Value(note),
        source: Value(source),
      ),
    );
  }

  Future<int> deleteSession(int id) {
    return (delete(
      muraqabaSessions,
    )..where((t) => t.id.equals(id))).go();
  }

  /// Deletes every session for [date] (used by the "not done" toggle).
  Future<int> deleteDay(String date) {
    return (delete(
      muraqabaSessions,
    )..where((t) => t.date.equals(date))).go();
  }

  // ── Aggregates ──────────────────────────────────────────────────────────

  /// Total minutes, sessions and distinct days inside [range].
  Future<MuraqabaRangeTotals> rangeTotals(DateRange range) async {
    final rows = await sessionsInRange(range);
    return MuraqabaRangeTotals(
      minutes: rows.fold(0, (sum, r) => sum + r.minutes),
      sessions: rows.length,
      days: rows.map((r) => r.date).toSet().length,
    );
  }

  /// Minutes practised per `yyyy-MM-dd` inside [range].
  Future<Map<String, int>> minutesByDay(DateRange range) async {
    final rows = await sessionsInRange(range);
    final map = <String, int>{};
    for (final row in rows) {
      map[row.date] = (map[row.date] ?? 0) + row.minutes;
    }
    return map;
  }

  /// Minutes practised in each month of [year] (index 0 = January).
  Future<List<int>> minutesByMonth(int year) async {
    final rows =
        await (select(muraqabaSessions)..where(
              (t) => t.date.like('$year-%'),
            ))
            .get();
    final months = List<int>.filled(12, 0);
    for (final row in rows) {
      final month = int.parse(row.date.substring(5, 7));
      if (month >= 1 && month <= 12) months[month - 1] += row.minutes;
    }
    return months;
  }

  /// Distinct days with at least one session inside [range].
  Future<Set<String>> daysWithPractice(DateRange range) async {
    final rows = await sessionsInRange(range);
    return rows.map((r) => r.date).toSet();
  }

  /// Current + best streak of days with at least one session.
  Future<StreakResult> streaks({required String todayYmd}) async {
    final query = selectOnly(muraqabaSessions)
      ..addColumns([muraqabaSessions.date])
      ..where(muraqabaSessions.date.isSmallerOrEqualValue(todayYmd))
      ..groupBy([muraqabaSessions.date]);
    final rows = await query.get();
    return computeStreak(
      completedDays: rows.map((r) => r.read(muraqabaSessions.date)!).toSet(),
      todayYmd: todayYmd,
    );
  }
}
