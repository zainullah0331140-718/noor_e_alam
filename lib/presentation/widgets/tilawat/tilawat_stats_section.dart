import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../db/enums.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/app_providers.dart';
import '../../../providers/tilawat_providers.dart';
import '../../../utils/date_utils_ext.dart';
import '../../../utils/numerals.dart';
import '../charts/donut_chart.dart';
import '../charts/simple_bar_chart.dart';
import 'tilawat_heatmap.dart';
import 'tilawat_position_card.dart' show tilawatUnitLabel;

/// Statistics block for the Tilawat module: totals, goal donut, streaks,
/// recitation heatmap and monthly page bars, driven by the range toggle.
class TilawatStatsSection extends ConsumerWidget {
  const TilawatStatsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final range = ref.watch(dashboardRangeProvider);
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month);
    final useEastern = ref.watch(numeralsProvider);

    final DateRange dbRange = switch (range) {
      DashboardRange.today => DateRange.dayOf(now),
      DashboardRange.month => DateRange.monthOf(now),
      DashboardRange.year => DateRange.yearOf(now),
    };

    final statsAsync = ref.watch(tilawatStatsProvider(dbRange));
    final streaks = ref.watch(tilawatStreakProvider);
    final monthlyAsync = ref.watch(tilawatYearProvider(now.year));
    final monthAsync = ref.watch(tilawatMonthProvider(monthStart));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        statsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Text('$e'),
          data: (stats) {
            if (stats.totals.entries == 0) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(l10n.noData),
                ),
              );
            }
            final achieved = stats.goalAchievedDays;
            final remaining = (stats.daysTotal - achieved).clamp(
              0,
              stats.daysTotal,
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _Stat(
                        icon: Icons.auto_stories,
                        label: stats.unit == TilawatUnit.pages
                            ? l10n.tilawatTotalPages
                            : tilawatUnitLabel(l10n, stats.unit),
                        value: formatNum(stats.amount, useEastern),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _Stat(
                        icon: Icons.calendar_today_outlined,
                        label: l10n.tilawatDaysRecited,
                        value: formatNum(stats.totals.days, useEastern),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _Stat(
                        icon: Icons.show_chart,
                        label: l10n.tilawatAveragePerDay,
                        value: formatNum(stats.averagePerDay, useEastern),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _Stat(
                        icon: Icons.flag_outlined,
                        label: l10n.tilawatGoalDays,
                        value: formatNum(achieved, useEastern),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        DonutChart(
                          size: 110,
                          thickness: 18,
                          centerTop: formatNum(
                            (stats.goalCompletion * 100).round(),
                            useEastern,
                          ),
                          centerBottom: l10n.tilawatGoalAchievement,
                          slices: [
                            DonutSlice(
                              label: l10n.tilawatGoalAchievement,
                              value: achieved.toDouble(),
                              color: const Color(0xFF1F8F4E),
                            ),
                            if (remaining > 0)
                              DonutSlice(
                                label: l10n.tilawatDaysRecited,
                                value: remaining.toDouble(),
                                color: scheme.surfaceContainerHighest,
                              ),
                          ],
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _LegendRow(
                                color: const Color(0xFF1F8F4E),
                                label: l10n.tilawatGoalAchievement,
                                value: formatNum(achieved, useEastern),
                              ),
                              const SizedBox(height: 4),
                              _LegendRow(
                                color: scheme.surfaceContainerHighest,
                                label: l10n.tilawatDaysRecited,
                                value: formatNum(stats.daysTotal, useEastern),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                streaks.when(
                  loading: () => const SizedBox.shrink(),
                  error: (e, _) => Text('$e'),
                  data: (s) => Row(
                    children: [
                      Expanded(
                        child: _Stat(
                          icon: Icons.local_fire_department_outlined,
                          label: l10n.currentStreak,
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
                const SizedBox(height: 14),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 16, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: 4,
                            bottom: 8,
                          ),
                          child: Text(
                            l10n.tilawatCalendarTitle,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        monthAsync.when(
                          loading: () => const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          error: (e, _) => Text('$e'),
                          data: (totals) => TilawatHeatmap(
                            month: monthStart,
                            totals: totals,
                            unit: stats.unit,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 14),
        monthlyAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (e, _) => Text('$e'),
          data: (months) => _MonthlyBars(months: months),
        ),
      ],
    );
  }
}

class _MonthlyBars extends StatelessWidget {
  final List<int> months;
  const _MonthlyBars({required this.months});

  @override
  Widget build(BuildContext context) {
    const labels = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
    final bars = [
      for (var i = 0; i < months.length && i < 12; i++)
        BarDatum(
          label: labels[i],
          value: months[i].toDouble(),
          color: const Color(0xFFB8860B),
        ),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 4, bottom: 8),
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

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  const _LegendRow({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
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
