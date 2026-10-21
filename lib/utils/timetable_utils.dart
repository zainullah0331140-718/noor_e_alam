import '../db/enums.dart';
import 'date_utils_ext.dart';

/// Pure helpers for the Daily Timetable module.
///
/// Occurrences are not stored in the database: a task's repeat rule is
/// evaluated against the requested day here, so editing a task immediately
/// updates past and future views.

/// Minutes in a day.
const int minutesPerDay = 24 * 60;

/// Monday-based weekday index (0 = Monday â€¦ 6 = Sunday).
int weekdayIndex(DateTime day) => day.weekday - 1;

/// Converts a set of Monday-based weekday indices into a bit mask.
int weekdayMaskFromSet(Set<int> days) {
  var mask = 0;
  for (final day in days) {
    if (day >= 0 && day <= 6) mask |= 1 << day;
  }
  return mask;
}

/// Expands a bit mask into Monday-based weekday indices.
Set<int> weekdaySetFromMask(int mask) {
  return {
    for (var day = 0; day <= 6; day++)
      if (mask & (1 << day) != 0) day,
  };
}

/// Weekday mask used by [TaskRepeat.weekdays] (Mondayâ€“Friday).
const int weekdaysMaskValue = 0x1F;

/// Whether [repeat] with [weekdaysMask] occurs on [day].
///
/// One-time tasks only occur on [anchorDate]; repeating tasks never occur
/// before it.
bool taskOccursOn({
  required TaskRepeat repeat,
  required int weekdaysMask,
  required String anchorDate,
  required DateTime day,
}) {
  final ymd = DateUtilsExt.ymd(day);
  if (ymd.compareTo(anchorDate) < 0) return false;
  switch (repeat) {
    case TaskRepeat.once:
      return ymd == anchorDate;
    case TaskRepeat.daily:
      return true;
    case TaskRepeat.weekdays:
      return weekdayIndex(day) <= 4;
    case TaskRepeat.customDays:
      return weekdaysMask & (1 << weekdayIndex(day)) != 0;
  }
}

/// Rounds [minutes] down/up to the nearest [step] (used by drag resize).
int snapMinutes(int minutes, {int step = 15}) {
  final rounded = (minutes / step).round() * step;
  return rounded.clamp(0, minutesPerDay);
}

/// Ensures a valid `[start, end)` pair with a minimum duration of [step].
(int, int) normaliseRange(int start, int end, {int step = 15}) {
  var s = start.clamp(0, minutesPerDay - step);
  var e = end.clamp(s + step, minutesPerDay);
  s = snapMinutes(s, step: step).clamp(0, minutesPerDay - step);
  e = snapMinutes(e, step: step).clamp(s + step, minutesPerDay);
  return (s, e);
}

/// Clamps a minute-of-day value into `[0, 1440)`.
int clampStart(int minutes) => minutes.clamp(0, minutesPerDay - 1);

/// Clamps a minute-of-day end value into `(start, 1440]`.
int clampEnd(int minutes, int start) =>
    minutes.clamp(start + 1, minutesPerDay);

/// Formats minutes-from-midnight as 24h `HH:mm` (stable, locale-neutral).
String format24h(int minutes) {
  final clamped = minutes.clamp(0, minutesPerDay);
  final h = (clamped ~/ 60) % 24;
  final m = clamped % 60;
  return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
}

/// Parses `HH:mm` into minutes-from-midnight, or null when invalid.
int? parse24h(String value) {
  final parts = value.split(':');
  if (parts.length != 2) return null;
  final h = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  if (h == null || m == null) return null;
  if (h < 0 || h > 23 || m < 0 || m > 59) return null;
  return h * 60 + m;
}

/// Total scheduled minutes for a list of `(start, end)` ranges.
int totalScheduledMinutes(Iterable<(int, int)> ranges) {
  return ranges.fold(0, (sum, range) => sum + (range.$2 - range.$1));
}

