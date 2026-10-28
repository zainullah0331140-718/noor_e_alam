import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../db/daos/ramadan_dao.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/ramadan_providers.dart';
import '../../../utils/numerals.dart';
import '../charts/donut_chart.dart';
import '../charts/progress_ring.dart';
import 'roza_day_tile.dart';

/// Fasting progress card: donut (fasted / excused / no-excuse / not logged),
/// a progress ring and the Taraweeh/Tahajjud night counts.
class RamadanProgressCard extends ConsumerWidget {
  final int seasonId;
  final bool useEastern;

  const RamadanProgressCard({
    super.key,
    required this.seasonId,
    required this.useEastern,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final totalsAsync = ref.watch(ramadanTotalsProvider(seasonId));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: totalsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('$e'),
          data: (totals) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.ramadanProgressTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  DonutChart(
                    size: 120,
                    thickness: 16,
                    centerTop: '${(totals.fastPercent * 100).round()}%',
                    centerBottom: l10n.ramadanFastPercent,
                    slices: [
                      DonutSlice(
                        label: l10n.ramadanFastedLabel,
                        value: totals.fasted.toDouble(),
                        color: RozaColors.fasted,
                      ),
                      DonutSlice(
                        label: l10n.ramadanExcusedLabel,
                        value: totals.missedExcused.toDouble(),
                        color: RozaColors.excused,
                      ),
                      DonutSlice(
                        label: l10n.ramadanNoExcuseLabel,
                        value: totals.missedNoExcuse.toDouble(),
                        color: RozaColors.noExcuse,
                      ),
                      DonutSlice(
                        label: l10n.ramadanNotRecordedLabel,
                        value: totals.notRecorded.toDouble(),
                        color: scheme.outlineVariant,
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: _legend(context, l10n, totals, useEastern)),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _MiniStat(
                      icon: Icons.nightlight_round,
                      label: l10n.ramadanTaraweehNights,
                      value: formatNum(totals.taraweehNights, useEastern),
                    ),
                  ),
                  Expanded(
                    child: _MiniStat(
                      icon: Icons.dark_mode_outlined,
                      label: l10n.ramadanTahajjudNights,
                      value: formatNum(totals.tahajjudNights, useEastern),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _legend(
    BuildContext context,
    AppLocalizations l10n,
    RamadanTotals totals,
    bool useEastern,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _legendRow(context, RozaColors.fasted, l10n.ramadanFastedLabel,
            totals.fasted, useEastern),
        const SizedBox(height: 6),
        _legendRow(context, RozaColors.excused, l10n.ramadanExcusedLabel,
            totals.missedExcused, useEastern),
        const SizedBox(height: 6),
        _legendRow(context, RozaColors.noExcuse, l10n.ramadanNoExcuseLabel,
            totals.missedNoExcuse, useEastern),
        const SizedBox(height: 6),
        _legendRow(
          context,
          Theme.of(context).colorScheme.outlineVariant,
          l10n.ramadanNotRecordedLabel,
          totals.notRecorded,
          useEastern,
        ),
      ],
    );
  }

  Widget _legendRow(
    BuildContext context,
    Color color,
    String label,
    int value,
    bool useEastern,
  ) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          formatNum(value, useEastern),
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

/// Qaza fasts summary with the pending count and a progress ring.
class RamadanQazaCard extends ConsumerWidget {
  final int seasonId;
  final bool useEastern;

  const RamadanQazaCard({
    super.key,
    required this.seasonId,
    required this.useEastern,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final totalsAsync = ref.watch(ramadanTotalsProvider(seasonId));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: totalsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('$e'),
          data: (totals) {
            final done = totals.missed - totals.qazaPending;
            final progress = totals.missed == 0
                ? 1.0
                : done / totals.missed;
            return Row(
              children: [
                ProgressRing(
                  size: 78,
                  stroke: 10,
                  progress: progress,
                  color: totals.qazaPending == 0
                      ? RozaColors.fasted
                      : scheme.tertiary,
                  centerTop: formatNum(totals.qazaPending, useEastern),
                  centerBottom: '/${formatNum(totals.missed, useEastern)}',
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.ramadanQazaTitle,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.ramadanQazaPending(totals.qazaPending),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: totals.qazaPending == 0
                              ? RozaColors.fasted
                              : scheme.tertiary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.ramadanExcusedLabel,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _MiniStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 20, color: scheme.primary),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}
