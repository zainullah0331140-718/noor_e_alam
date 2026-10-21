import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/app_providers.dart';
import '../../../providers/khatam_providers.dart';
import '../../../utils/numerals.dart';
import '../charts/simple_bar_chart.dart';

/// Counters, yearly goal progress and per-year bar chart for khatams.
class KhatamStatsSection extends ConsumerWidget {
  const KhatamStatsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final useEastern = ref.watch(numeralsProvider);
    final goal = ref.watch(khatamGoalProvider);
    final countsAsync = ref.watch(khatamCountsProvider);

    return countsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Text('$e'),
      data: (counts) {
        final progress = goal == 0
            ? 0.0
            : (counts.thisYear / goal).clamp(0.0, 1.0).toDouble();
        final years = counts.byYear.keys.toList()..sort();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _Stat(
                    icon: Icons.calendar_today_outlined,
                    label: l10n.khatamThisYear,
                    value: formatNum(counts.thisYear, useEastern),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _Stat(
                    icon: Icons.auto_stories,
                    label: l10n.khatamAllTime,
                    value: formatNum(counts.allTime, useEastern),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _Stat(
                    icon: Icons.flag_outlined,
                    label: l10n.khatamYearGoal,
                    value: formatNum(goal, useEastern),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.khatamGoalProgress(counts.thisYear, goal),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 8),
                      child: Text(
                        l10n.khatamYearlyTitle,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    if (years.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          l10n.noData,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      )
                    else
                      SimpleBarChart(
                        height: 150,
                        bars: [
                          for (final y in years)
                            BarDatum(
                              label: y.toString().substring(2),
                              value: (counts.byYear[y] ?? 0).toDouble(),
                              color: const Color(0xFF3D5A80),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
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
