// Azkar statistics: totals, completion donut, per-dhikr breakdown, streaks and daily bars.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/app_providers.dart';
import '../../../providers/azkar_providers.dart';
import '../../../utils/date_utils_ext.dart';
import '../../../utils/numerals.dart';
import '../azkar/azkar_dhikr_tile.dart';
import '../charts/donut_chart.dart';
import '../charts/simple_bar_chart.dart';

/// Range-scoped Azkar stats block driven by the shared range toggle.
class AzkarStatsSection extends ConsumerWidget {
  const AzkarStatsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(dashboardRangeProvider);
    final now = DateTime.now();
    final useEastern = ref.watch(numeralsProvider);

    final DateRange dbRange = switch (range) {
      DashboardRange.today => DateRange.dayOf(now),
      DashboardRange.month => DateRange.monthOf(now),
      DashboardRange.year => DateRange.yearOf(now),
    };

    final statsAsync = ref.watch(azkarStatsProvider(dbRange));
    final streaks = ref.watch(azkarStreakProvider);

    return statsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Text('$e'),
      data: (stats) {
        final l10n = AppLocalizations.of(context)!;
        if (stats.totalCount == 0) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(l10n.noData),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _Stat(
                    icon: Icons.radio_button_checked,
                    label: l10n.azkarCountLabel,
                    value: formatNum(stats.totalCount, useEastern),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _Stat(
                    icon: Icons.pie_chart_outline,
                    label: l10n.completion,
                    value:
                        '${formatNum((stats.completion * 100).round(), useEastern)}%',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _CompletionDonut(
              completion: stats.completion,
              useEastern: useEastern,
            ),
            const SizedBox(height: 14),
            _DhikrDonut(byDhikr: stats.byDhikr, useEastern: useEastern),
            const SizedBox(height: 14),
            streaks.when(
              loading: () => const SizedBox.shrink(),
              error: (e, _) => Text('$e'),
              data: (s) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Expanded(
                        child: _Stat(
                          icon: Icons.local_fire_department_outlined,
                          label: l10n.azkarStreak,
                          value: l10n.streakValue(s.current),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _Stat(
                          icon: Icons.emoji_events_outlined,
                          label: l10n.bestStreak,
                          value: l10n.streakValue(s.best),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            _MonthlyBars(
              byDay: stats.byDay,
              month: now,
              useEastern: useEastern,
            ),
          ],
        );
      },
    );
  }
}

class _CompletionDonut extends StatelessWidget {
  final double completion;
  final bool useEastern;
  const _CompletionDonut({required this.completion, required this.useEastern});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final done = completion.clamp(0.0, 1.0);
    final rest = 1 - done;
    final slices = [
      DonutSlice(
        label: l10n.completion,
        value: done,
        color: const Color(0xFF6A4C93),
      ),
      if (rest > 0.001)
        DonutSlice(
          label: l10n.azkarCountLabel,
          value: rest,
          color: scheme.surfaceContainerHighest,
        ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            DonutChart(
              size: 110,
              thickness: 18,
              centerTop: '${formatNum((done * 100).round(), useEastern)}%',
              centerBottom: l10n.completion,
              slices: slices,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final s in slices)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: s.color,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              s.label,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          Text(
                            '${formatNum((s.value * 100).round(), useEastern)}%',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DhikrDonut extends StatelessWidget {
  final Map<String, int> byDhikr;
  final bool useEastern;
  const _DhikrDonut({required this.byDhikr, required this.useEastern});

  static const _palette = [
    Color(0xFF1F8F4E),
    Color(0xFFD9B75B),
    Color(0xFF1FB8B8),
    Color(0xFFB8860B),
    Color(0xFF6A4C93),
    Color(0xFFE07A5F),
    Color(0xFF3D5A80),
    Color(0xFF81B29A),
    Color(0xFFF2CC8F),
    Color(0xFF9B2226),
    Color(0xFF457B9D),
  ];

  String _label(AppLocalizations l10n, String key) =>
      key.startsWith('custom:') ? l10n.azkarCustomTitle : azkarLabel(l10n, key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final active = byDhikr.entries.where((e) => e.value > 0).toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    if (active.isEmpty) return const SizedBox.shrink();
    final top = active.take(6).toList();

    final slices = [
      for (var i = 0; i < top.length; i++)
        DonutSlice(
          label: _label(l10n, top[i].key),
          value: top[i].value.toDouble(),
          color: _palette[i % _palette.length],
        ),
    ];
    final total = top.fold<int>(0, (s, e) => s + e.value);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 2, bottom: 10),
              child: Text(
                l10n.azkarPieTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Row(
              children: [
                DonutChart(
                  size: 110,
                  thickness: 18,
                  centerTop: formatNum(total, useEastern),
                  centerBottom: l10n.azkarCountLabel,
                  slices: slices,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < slices.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: slices[i].color,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  slices[i].label,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              Text(
                                formatNum(top[i].value, useEastern),
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthlyBars extends StatelessWidget {
  final Map<String, int> byDay;
  final DateTime month;
  final bool useEastern;
  const _MonthlyBars({
    required this.byDay,
    required this.month,
    required this.useEastern,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final bars = [
      for (var d = 1; d <= daysInMonth; d++)
        BarDatum(
          label: '$d',
          value:
              (byDay[DateUtilsExt.ymd(DateTime(month.year, month.month, d))] ??
                      0)
                  .toDouble(),
          color: const Color(0xFF6A4C93),
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
            SimpleBarChart(
              bars: bars,
              height: 150,
              valueFormatter: (v) => formatNum(v.toInt(), useEastern),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _Stat({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: scheme.primary),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
