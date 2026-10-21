import 'package:intl/intl.dart';

/// Inclusive ymd date helpers + a lightweight inclusive range type used by
/// DAO aggregation queries and report providers.
class DateUtilsExt {
  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
  static String ymd(DateTime d) => DateFormat('yyyy-MM-dd').format(dateOnly(d));
  static String pretty(DateTime d) => DateFormat('EEE, dd MMM yyyy').format(d);

  static DateTime parseYmd(String ymd) => DateTime(
    int.parse(ymd.substring(0, 4)),
    int.parse(ymd.substring(5, 7)),
    int.parse(ymd.substring(8, 10)),
  );
}

/// Inclusive range of calendar days, expressed as `yyyy-MM-dd` strings so
/// it can be compared lexically in SQL.
class DateRange {
  final String startYmd;
  final String endYmd;

  const DateRange({required this.startYmd, required this.endYmd});

  /// The full calendar month containing [date].
  factory DateRange.monthOf(DateTime date) {
    final start = DateTime(date.year, date.month, 1);
    final end = DateTime(date.year, date.month + 1, 0);
    return DateRange(
      startYmd: DateUtilsExt.ymd(start),
      endYmd: DateUtilsExt.ymd(end),
    );
  }

  /// The full calendar year containing [date].
  factory DateRange.yearOf(DateTime date) {
    return DateRange(
      startYmd: DateUtilsExt.ymd(DateTime(date.year, 1, 1)),
      endYmd: DateUtilsExt.ymd(DateTime(date.year, 12, 31)),
    );
  }

  /// A single day.
  factory DateRange.dayOf(DateTime date) {
    final y = DateUtilsExt.ymd(date);
    return DateRange(startYmd: y, endYmd: y);
  }
}
