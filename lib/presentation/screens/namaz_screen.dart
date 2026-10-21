import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../db/daos/namaz_dao.dart';
import '../../db/enums.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../../providers/namaz_providers.dart';
import '../../providers/settings_providers.dart';
import '../../utils/date_utils_ext.dart';
import '../widgets/charts/simple_bar_chart.dart';
import '../widgets/common/date_selector.dart';
import '../widgets/common/month_year_toggle.dart';
import '../widgets/namaz/daily_summary_bar.dart';
import '../widgets/namaz/namaz_month_calendar.dart';
import '../widgets/namaz/prayer_card.dart';
import '../widgets/namaz/qaza_tab.dart';

/// Namaz module: Day tracker + History/Stats + Qaza manager.
class NamazScreen extends ConsumerStatefulWidget {
  const NamazScreen({super.key});

  @override
  ConsumerState<NamazScreen> createState() => _NamazScreenState();
}

class _NamazScreenState extends ConsumerState<NamazScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 3, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        TabBar(
          controller: _tabs,
          tabs: [
            Tab(text: l10n.rangeToday),
            Tab(text: l10n.moduleReports),
            Tab(text: l10n.tabQaza),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabs,
            children: const [
              _NamazDayTab(),
              _NamazHistoryTab(),
              QazaTab(),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Day tab ───────────────────────────────────────────────────────────────

class _NamazDayTab extends ConsumerWidget {
  const _NamazDayTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(selectedDayProvider);
    final ymd = DateUtilsExt.ymd(day);
    final rowsAsync = ref.watch(namazDayProvider(ymd));
    final countsAsync = ref.watch(namazDayCountsProvider(ymd));
    final times = ref.watch(prayerTimesProvider(day));
    final useEastern = ref.watch(numeralsProvider);

    void changeDay(DateTime d) => ref.read(selectedDayProvider.notifier).set(d);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        DateSelector(date: day, onChanged: changeDay),
        const SizedBox(height: 12),
        countsAsync.when(
          loading: () => const _LoadingCard(),
          error: (e, _) => Text('$e'),
          data: (c) => DailySummaryBar(
            jamaat: c.jamaat,
            alone: c.alone,
            missed: c.missed,
            remaining: c.none,
            useEastern: useEastern,
          ),
        ),
        const SizedBox(height: 16),
        rowsAsync.when(
          loading: () => const _LoadingCard(),
          error: (e, _) => Text('$e'),
          data: (rows) {
            return Column(
              children: [
                for (final type in NamazType.values) ...[
                  PrayerCard(
                    type: type,
                    status: rows[type]?.status ?? NamazStatus.none,
                    timeLabel: times[type] == null
                        ? null
                        : _clock(context, times[type]!),
                    takbeerUla: rows[type]?.takbeerUla ?? false,
                    masbooq: rows[type]?.masbooq ?? false,
                    atMasjid: rows[type]?.atMasjid ?? false,
                    enabled: !day.isAfter(DateUtilsExt.dateOnly(DateTime.now())),
                    onStatusChanged: (status) {
                      ref
                          .read(namazActionsProvider)
                          .setStatus(
                            day: day,
                            prayer: type,
                            status: status,
                            takbeerUla: rows[type]?.takbeerUla ?? false,
                            masbooq: rows[type]?.masbooq ?? false,
                            atMasjid: rows[type]?.atMasjid ?? false,
                          );
                    },
                    onFlagsChanged: ({required takbeerUla, required masbooq, required atMasjid}) {
                      ref
                          .read(namazActionsProvider)
                          .setFlags(
                            day: day,
                            prayer: type,
                            takbeerUla: takbeerUla,
                            masbooq: masbooq,
                            atMasjid: atMasjid,
                          );
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  String _clock(BuildContext context, DateTime t) {
    return MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay.fromDateTime(t),
      alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
    );
  }
}

// ── History/Stats tab ─────────────────────────────────────────────────────

class _NamazHistoryTab extends ConsumerStatefulWidget {
  const _NamazHistoryTab();

  @override
  ConsumerState<_NamazHistoryTab> createState() => _NamazHistoryTabState();
}

class _NamazHistoryTabState extends ConsumerState<_NamazHistoryTab> {
  @override
  Widget build(BuildContext context) {
    final range = ref.watch(dashboardRangeProvider);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        const Center(child: MonthYearToggle()),
        const SizedBox(height: 16),
        switch (range) {
          DashboardRange.today => const _DayStats(),
          DashboardRange.month => const _MonthStats(),
          DashboardRange.year => const _YearStats(),
        },
      ],
    );
  }
}

class _DayStats extends ConsumerWidget {
  const _DayStats();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final streak = ref.watch(namazStreakProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        streak.when(
          loading: () => const _LoadingCard(),
          error: (e, _) => Text('$e'),
          data: (s) => Row(
            children: [
              Expanded(
                child: _StatTile(
                  title: l10n.currentStreak,
                  value: l10n.streakValue(s.current),
                  icon: Icons.local_fire_department,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatTile(
                  title: l10n.bestStreak,
                  value: l10n.streakValue(s.best),
                  icon: Icons.emoji_events_outlined,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MonthStats extends ConsumerWidget {
  const _MonthStats();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final analysis = ref.watch(namazMonthAnalysisProvider(now));
    final streak = ref.watch(namazStreakProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NamazMonthCalendar(
          month: now,
          onTapDay: (day) =>
              ref.read(selectedDayProvider.notifier).set(day),
        ),
        const SizedBox(height: 16),
        streak.when(
          loading: () => const _LoadingCard(),
          error: (e, _) => Text('$e'),
          data: (s) => Row(
            children: [
              Expanded(
                child: _StatTile(
                  title: l10n.currentStreak,
                  value: l10n.streakValue(s.current),
                  icon: Icons.local_fire_department,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatTile(
                  title: l10n.bestStreak,
                  value: l10n.streakValue(s.best),
                  icon: Icons.emoji_events_outlined,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        analysis.when(
          loading: () => const _LoadingCard(),
          error: (e, _) => Text('$e'),
          data: (a) => _AnalysisSummary(a: a),
        ),
        const SizedBox(height: 8),
        Text(l10n.tapDateToEdit, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _YearStats extends ConsumerWidget {
  const _YearStats();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final year = DateTime.now().year;
    final analysis = ref.watch(namazYearAnalysisProvider(year));
    final monthly = ref.watch(namazYearProvider(year));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        monthly.when(
          loading: () => const _LoadingCard(),
          error: (e, _) => Text('$e'),
          data: (months) => _YearBarChart(months: months),
        ),
        const SizedBox(height: 12),
        analysis.when(
          loading: () => const _LoadingCard(),
          error: (e, _) => Text('$e'),
          data: (a) => _AnalysisSummary(a: a, showMostMissed: true, l10n: l10n),
        ),
      ],
    );
  }
}

/// 12-month bar chart with total jamaat / alone / missed.
class _YearBarChart extends StatelessWidget {
  final List<NamazRangeCounts> months;
  const _YearBarChart({required this.months});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const labels = [
      'J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D',
    ];
    final bars = <BarDatum>[
      for (var i = 0; i < months.length && i < 12; i++)
        BarDatum(
          label: labels[i],
          value: (months[i].jamaat + months[i].alone).toDouble(),
          color: const Color(0xFF1F8F4E),
        ),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                l10n.monthlyTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            SimpleBarChart(bars: bars, height: 170),
          ],
        ),
      ),
    );
  }
}

class _AnalysisSummary extends StatelessWidget {
  final NamazAnalysis a;
  final bool showMostMissed;
  final AppLocalizations? l10n;
  const _AnalysisSummary({
    required this.a,
    this.showMostMissed = true,
    this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final most = a.mostMissed;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _StatTile(
                title: t.jamaat,
                value: '${a.totals.jamaat}',
                icon: Icons.groups,
                color: const Color(0xFF1F8F4E),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _StatTile(
                title: t.alone,
                value: '${a.totals.alone}',
                icon: Icons.person,
                color: const Color(0xFFD9B75B),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _StatTile(
                title: t.missed,
                value: '${a.totals.missed}',
                icon: Icons.close,
                color: const Color(0xFFD32F2F),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _StatTile(
          title: t.jamaatPercentLabel,
          value: '${a.totals.jamaatPercent.toStringAsFixed(0)}%',
          icon: Icons.percent,
        ),
        if (showMostMissed && most != null) ...[
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Theme.of(context).colorScheme.error),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${t.mostMissedTitle}: '
                      '${t.mostMissedValue(_prayerName(context, most), a.missedByPrayer[most] ?? 0)}',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _prayerName(BuildContext context, NamazType type) {
    final t = AppLocalizations.of(context)!;
    switch (type) {
      case NamazType.fajr:
        return t.prayerFajr;
      case NamazType.zuhr:
        return t.prayerZuhr;
      case NamazType.asr:
        return t.prayerAsr;
      case NamazType.maghrib:
        return t.prayerMaghrib;
      case NamazType.isha:
        return t.prayerIsha;
      case NamazType.witr:
        return t.prayerWitr;
    }
  }
}

class _StatTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;
  const _StatTile({
    required this.title,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: color ?? scheme.primary),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
