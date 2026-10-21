import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../db/enums.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/app_providers.dart';
import '../../../providers/nafl_providers.dart';
import '../../../utils/date_utils_ext.dart';
import '../../../utils/numerals.dart';
import '../charts/donut_chart.dart';
import '../charts/simple_bar_chart.dart';
import '../prayer_labels.dart';

/// Statistics block for the Nafl module: totals, per-type donut, monthly
/// bar chart and Tahajjud/Duha streaks, driven by the shared range toggle.
class NaflStatsSection extends ConsumerWidget {
  const NaflStatsSection({super.key});

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

    final statsAsync = ref.watch(naflStatsProvider(dbRange));
    final streaks = ref.watch(naflStreaksProvider);
    final monthlyAsync = ref.watch(naflYearProvider(now.year));

    return statsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Text('$e'),
      data: (stats) {
        if (stats.rakats == 0 && stats.daysPerformed == 0) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(AppLocalizations.of(context)!.noData),
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
                    icon: Icons.auto_awesome,
                    label: AppLocalizations.of(context)!.naflRakatsLabel,
                    value: formatNum(stats.rakats, useEastern),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _Stat(
                    icon: Icons.checklist,
                    label: AppLocalizations.of(context)!.daysPerformedLabel,
                    value: formatNum(stats.daysPerformed, useEastern),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _TypeDonut(byType: stats.byType, useEastern: useEastern),
            const SizedBox(height: 14),
            streaks.when(
              loading: () => const SizedBox.shrink(),
              error: (e, _) => Text('$e'),
              data: (s) => Row(
                children: [
                  Expanded(
                    child: _Stat(
                      icon: Icons.nights_stay_outlined,
                      label: AppLocalizations.of(context)!.streakTahajjud,
                      value: AppLocalizations.of(
                        context,
                      )!.streakValue(s.tahajjud),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _Stat(
                      icon: Icons.wb_twilight,
                      label: AppLocalizations.of(context)!.streakDuha,
                      value: AppLocalizations.of(context)!.streakValue(s.duha),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            monthlyAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (e, _) => Text('$e'),
              data: (months) => _MonthlyBars(months: months),
            ),
          ],
        );
      },
    );
  }
}

class _TypeDonut extends StatelessWidget {
  final Map<NaflType, int> byType;
  final bool useEastern;
  const _TypeDonut({required this.byType, required this.useEastern});

  // A distinct, readable palette for the per-type breakdown.
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final active = byType.entries.where((e) => e.value > 0).toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    if (active.isEmpty) return const SizedBox.shrink();

    final slices = <DonutSlice>[];
    for (var i = 0; i < active.length; i++) {
      slices.add(
        DonutSlice(
          label: PrayerLabels.nafl(l10n, active[i].key, ''),
          value: active[i].value.toDouble(),
          color: _palette[i % _palette.length],
        ),
      );
    }
    final total = active.fold<int>(0, (s, e) => s + e.value);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            DonutChart(
              size: 110,
              thickness: 18,
              centerTop: formatNum(total, useEastern),
              centerBottom: l10n.naflRakatsLabel,
              slices: slices,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < active.length && i < 6; i++)
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
                            formatNum(active[i].value, useEastern),
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

class _MonthlyBars extends StatelessWidget {
  final List<int> months;
  const _MonthlyBars({required this.months});

  @override
  Widget build(BuildContext context) {
    const labels = [
      'J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D',
    ];
    final bars = [
      for (var i = 0; i < months.length && i < 12; i++)
        BarDatum(
          label: labels[i],
          value: months[i].toDouble(),
          color: const Color(0xFF1FB8B8),
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
                AppLocalizations.of(context)!.monthlyTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            SimpleBarChart(bars: bars, height: 150),
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
  const _Stat({
    required this.icon,
    required this.label,
    required this.value,
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
