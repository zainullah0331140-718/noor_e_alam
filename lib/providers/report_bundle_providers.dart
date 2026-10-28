import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/enums.dart';
import '../utils/date_utils_ext.dart';
import '../utils/streak_utils.dart';
import 'azkar_providers.dart';
import 'gheebat_providers.dart';
import 'khatam_providers.dart';
import 'muraqaba_providers.dart';
import 'nafl_providers.dart';
import 'namaz_providers.dart';
import 'ramadan_providers.dart';
import 'tilawat_providers.dart';

/// One row of the report summary table (a single module's numbers).
class ReportRow {
  /// Stable module key (used to toggle inclusion + as a column key).
  final String key;

  /// English module label.
  final String labelEn;

  /// Urdu module label.
  final String labelUr;

  final int done;
  final int total;

  const ReportRow({
    required this.key,
    required this.labelEn,
    required this.labelUr,
    required this.done,
    required this.total,
  });

  /// Completion percentage (integer, 0..100).
  int get percent => total == 0 ? 0 : ((done / total) * 100).round();
}

/// Which report granularity the user picked.
enum ReportPeriod { day, month, year }

/// A fully-assembled, printable snapshot of every module for one range.
class ReportBundle {
  final DateRange range;
  final String rangeLabel;
  final DateTime generatedAt;
  final List<ReportRow> rows;

  const ReportBundle({
    required this.range,
    required this.rangeLabel,
    required this.generatedAt,
    required this.rows,
  });

  /// Rows restricted to the user's selected module keys.
  List<ReportRow> selected(List<String> keys) {
    if (keys.isEmpty) return rows;
    return rows.where((r) => keys.contains(r.key)).toList();
  }
}

/// All module keys, in report order.
const reportModuleKeys = <String>[
  'namaz',
  'nafl',
  'tilawat',
  'azkar',
  'gheebat',
  'muraqaba',
  'khatam',
  'ramadan',
];

/// The selected report period (drives which range is assembled).
class ReportPeriodNotifier extends Notifier<ReportPeriod> {
  @override
  ReportPeriod build() => ReportPeriod.month;
  void set(ReportPeriod p) => state = p;
}

final reportPeriodProvider =
    NotifierProvider<ReportPeriodNotifier, ReportPeriod>(
      ReportPeriodNotifier.new,
    );

/// A stable anchor date for the report (today, unless overridden).
class ReportAnchorNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateUtilsExt.dateOnly(DateTime.now());
  void set(DateTime d) => state = DateUtilsExt.dateOnly(d);

  /// Moves the anchor by [delta] units of [period] (days / months / years).
  void shiftPeriod(ReportPeriod period, int delta) {
    final current = state;
    final next = switch (period) {
      ReportPeriod.day =>
        DateTime(current.year, current.month, current.day + delta),
      ReportPeriod.month =>
        _clampDay(current.year, current.month + delta, current.day),
      ReportPeriod.year =>
        _clampDay(current.year + delta, current.month, current.day),
    };
    state = DateUtilsExt.dateOnly(next);
  }

  /// Builds [year]/[month]/[day], clamping [day] to the target month's length
  /// so e.g. 31 Jan − 1 month lands on 28/29 Feb instead of overflowing.
  static DateTime _clampDay(int year, int month, int day) {
    final first = DateTime(year, month, 1);
    final lastDay = DateTime(first.year, first.month + 1, 0).day;
    return DateTime(first.year, first.month, day.clamp(1, lastDay).toInt());
  }
}

final reportAnchorProvider = NotifierProvider<ReportAnchorNotifier, DateTime>(
  ReportAnchorNotifier.new,
);

/// Which module keys are included in the report.
class ReportSelectionNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => reportModuleKeys.toSet();

  void toggle(String key) {
    final next = {...state};
    if (!next.remove(key)) next.add(key);
    state = next;
  }

  void all() => state = reportModuleKeys.toSet();
}

final reportSelectionProvider =
    NotifierProvider<ReportSelectionNotifier, Set<String>>(
      ReportSelectionNotifier.new,
    );

/// Convenience: the DateRange produced by the current period + anchor.
final reportRangeProvider = Provider<DateRange>((ref) {
  final period = ref.watch(reportPeriodProvider);
  final anchor = ref.watch(reportAnchorProvider);
  return switch (period) {
    ReportPeriod.day => DateRange.dayOf(anchor),
    ReportPeriod.month => DateRange.monthOf(anchor),
    ReportPeriod.year => DateRange.yearOf(anchor),
  };
});

/// Human-readable range label, localized by the screen (kept neutral here).
final reportRangeLabelProvider = Provider<String>((ref) {
  final period = ref.watch(reportPeriodProvider);
  final anchor = ref.watch(reportAnchorProvider);
  return switch (period) {
    ReportPeriod.day => DateUtilsExt.pretty(anchor),
    ReportPeriod.month =>
      '${anchor.year}-${anchor.month.toString().padLeft(2, '0')}',
    ReportPeriod.year => '${anchor.year}',
  };
});

/// Assembles the full report bundle from every module DAO for the range.
final reportBundleProvider = FutureProvider<ReportBundle>((ref) async {
  final requested = ref.watch(reportRangeProvider);
  final label = ref.watch(reportRangeLabelProvider);
  final now = DateTime.now();

  // The current month/year is reported "to date": counting days that have not
  // happened yet would keep every percentage pinned near zero until the range
  // ends. Past and future ranges keep their full span.
  final todayYmd = DateUtilsExt.ymd(now);
  final range =
      requested.startYmd.compareTo(todayYmd) <= 0 &&
          requested.endYmd.compareTo(todayYmd) > 0
      ? DateRange(startYmd: requested.startYmd, endYmd: todayYmd)
      : requested;

  // ── Namaz ───────────────────────────────────────────────────────────────
  final namazDao = ref.watch(namazDaoProvider);
  final namazTotals = await namazDao.rangeCounts(range);

  // ── Nafl ────────────────────────────────────────────────────────────────
  final naflTotals = await ref.watch(naflDaoProvider).rangeTotals(range);

  // ── Tilawat ─────────────────────────────────────────────────────────────
  final tilawatUnit = ref.watch(tilawatUnitProvider);
  final tilawatGoal = ref.watch(tilawatGoalProvider);
  final tilawatTotals = await ref
      .watch(tilawatDaoProvider)
      .rangeTotals(range);

  // ── Azkar ───────────────────────────────────────────────────────────────
  final azkarStats = await ref.watch(azkarStatsProvider(range).future);

  // ── Gheebat ─────────────────────────────────────────────────────────────
  final gheebatTotals = await ref.watch(gheebatDaoProvider).rangeTotals(range);

  // ── Muraqaba ────────────────────────────────────────────────────────────
  final muraqabaTotals = await ref
      .watch(muraqabaDaoProvider)
      .rangeTotals(range);

  // ── Khatam ──────────────────────────────────────────────────────────────
  final allKhatams = await ref.watch(khatamDaoProvider).watchAll().first;
  final khatamsCompleted = allKhatams
      .where((k) => k.endDate != null)
      .where(
        (k) =>
            k.endDate!.compareTo(range.startYmd) >= 0 &&
            k.endDate!.compareTo(range.endYmd) <= 0,
      )
      .length;

  // ── Ramadan (active season) ─────────────────────────────────────────────
  final ramadanSeason = await ref.watch(ramadanActiveSeasonProvider.future);
  final ramadanTotals = await ref
      .watch(ramadanDaoProvider)
      .seasonTotals(ramadanSeason.id);

  final rangeDays =
      daysInRange(range.startYmd, range.endYmd).clamp(1, 366);

  final rows = <ReportRow>[
    ReportRow(
      key: 'namaz',
      labelEn: 'Namaz (5 Fard + Witr)',
      labelUr: 'نماز (پانچ فرض + وتر)',
      done: namazTotals.prayed,
      total: rangeDays * NamazType.values.length,
    ),
    ReportRow(
      key: 'nafl',
      labelEn: 'Nafl (rakats)',
      labelUr: 'نفل (رکعتیں)',
      done: naflTotals.rakats,
      total: naflTotals.rakats == 0 ? 0 : naflTotals.rakats,
    ),
    ReportRow(
      key: 'tilawat',
      labelEn: 'Tilawat (${tilawatUnit.name})',
      labelUr: 'تلاوت (${_urduUnit(tilawatUnit)})',
      done: tilawatTotals.amountFor(tilawatUnit),
      total: rangeDays * tilawatGoal,
    ),
    ReportRow(
      key: 'azkar',
      labelEn: 'Azkar',
      labelUr: 'اذکار',
      done: azkarStats.clampedDone,
      total: azkarStats.expectedTotal,
    ),
    ReportRow(
      key: 'gheebat',
      labelEn: 'Gheebat-free days',
      labelUr: 'غیبت سے پاک دن',
      done: gheebatTotals.free,
      total: gheebatTotals.recorded,
    ),
    ReportRow(
      key: 'muraqaba',
      labelEn: 'Muraqaba (minutes)',
      labelUr: 'مراقبہ (منٹ)',
      done: muraqabaTotals.minutes,
      total: muraqabaTotals.days * 15,
    ),
    ReportRow(
      key: 'khatam',
      labelEn: 'Quran khatam',
      labelUr: 'ختمِ قرآن',
      done: khatamsCompleted,
      total: khatamsCompleted == 0 ? 1 : khatamsCompleted,
    ),
    ReportRow(
      key: 'ramadan',
      labelEn: 'Ramadan fasts',
      labelUr: 'رمضان کے روزے',
      done: ramadanTotals.fasted,
      total: 30,
    ),
  ];

  return ReportBundle(
    range: range,
    rangeLabel: label,
    generatedAt: now,
    rows: rows,
  );
});

String _urduUnit(TilawatUnit unit) {
  switch (unit) {
    case TilawatUnit.pages:
      return 'صفحات';
    case TilawatUnit.ruku:
      return 'رکوع';
    case TilawatUnit.para:
      return 'پارہ';
    case TilawatUnit.minutes:
      return 'منٹ';
  }
}
