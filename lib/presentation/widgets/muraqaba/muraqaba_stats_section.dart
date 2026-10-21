import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/app_providers.dart';
import '../../../providers/muraqaba_providers.dart';
import '../../../utils/date_utils_ext.dart';
import '../../../utils/numerals.dart';
import '../charts/progress_ring.dart';

/// Statistics block for the Muraqaba module: totals, streaks and the
/// completion ring for the given date range.
class MuraqabaStatsSection extends ConsumerWidget {
  final DateRange range;

  const MuraqabaStatsSection({super.key, required this.range});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final useEastern = ref.watch(numeralsProvider);
    final statsAsync = ref.watch(muraqabaStatsProvider(range));
    final streaks = ref.watch(muraqabaStreakProvider);

    return statsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Text('$e'),
      data: (stats) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _Stat(
                  icon: Icons.timer_outlined,
                  label: l10n.muraqabaTotalMinutes,
                  value: formatNum(stats.minutes, useEastern),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Stat(
                  icon: Icons.self_improvement,
                  label: l10n.muraqabaSessionsLabel,
                  value: formatNum(stats.sessions, useEastern),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _Stat(
                  icon: Icons.calendar_today_outlined,
                  label: l10n.muraqabaDaysLabel,
                  value: formatNum(stats.days, useEastern),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Stat(
                  icon: Icons.show_chart,
                  label: l10n.muraqabaAverageLabel,
                  value: formatNum(stats.totals.averageMinutes, useEastern),
                ),
              ),
            ],
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
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  ProgressRing(
                    progress: stats.consistency,
                    size: 110,
                    stroke: 12,
                    centerTop:
                        '${formatNum((stats.consistency * 100).round(), useEastern)}%',
                    centerBottom: l10n.completion,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _LegendRow(
                          label: l10n.muraqabaDaysLabel,
                          value: formatNum(stats.days, useEastern),
                        ),
                        const SizedBox(height: 6),
                        _LegendRow(
                          label: l10n.rangeMonth,
                          value: formatNum(stats.daysTotal, useEastern),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final String label;
  final String value;

  const _LegendRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
