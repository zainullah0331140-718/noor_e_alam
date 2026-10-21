/// Shared streak arithmetic for the Tilawat and Azkar modules.
///
/// A "completed day" is any `yyyy-MM-dd` string in the input set. Streaks
/// are computed over consecutive calendar days, with an optional grace for
/// today (an unfinished today does not break the run).
library;

import 'date_utils_ext.dart';

/// Current + best consecutive-day counts.
class StreakResult {
  final int current;
  final int best;
  const StreakResult(this.current, this.best);

  static const empty = StreakResult(0, 0);
}

/// Computes the current and best consecutive-day streak from [completedDays]
/// (a set of `yyyy-MM-dd` strings).
///
/// If [todayYmd] is not itself complete, the current streak counts back from
/// yesterday — so the run is not visibly broken until the day is over.
StreakResult computeStreak({
  required Set<String> completedDays,
  required String todayYmd,
}) {
  if (completedDays.isEmpty) return StreakResult.empty;

  // Best streak: longest run in the sorted day list.
  final sorted = completedDays.toList()..sort();
  var best = 1;
  var run = 1;
  for (var i = 1; i < sorted.length; i++) {
    final prev = DateUtilsExt.parseYmd(sorted[i - 1]);
    final cur = DateUtilsExt.parseYmd(sorted[i]);
    if (_calendarDaysBetween(prev, cur) == 1) {
      run++;
      if (run > best) best = run;
    } else {
      run = 1;
    }
  }

  // Current streak: walk backwards from today (or yesterday for grace).
  var cursor = DateUtilsExt.parseYmd(todayYmd);
  if (!completedDays.contains(todayYmd)) {
    cursor = _shiftDay(cursor, -1);
  }
  var current = 0;
  while (completedDays.contains(DateUtilsExt.ymd(cursor))) {
    current++;
    cursor = _shiftDay(cursor, -1);
  }

  return StreakResult(current, best);
}

/// Inclusive number of calendar days in a `yyyy-MM-dd` range.
int daysInRange(String startYmd, String endYmd) {
  final start = DateUtilsExt.parseYmd(startYmd);
  final end = DateUtilsExt.parseYmd(endYmd);
  return _calendarDaysBetween(start, end) + 1;
}

/// Calendar-day arithmetic that stays stable across DST transitions.
DateTime _shiftDay(DateTime d, int delta) =>
    DateTime(d.year, d.month, d.day + delta);

int _calendarDaysBetween(DateTime a, DateTime b) => DateTime.utc(
  b.year,
  b.month,
  b.day,
).difference(DateTime.utc(a.year, a.month, a.day)).inDays;
