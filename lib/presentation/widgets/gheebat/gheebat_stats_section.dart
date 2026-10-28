import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/app_providers.dart';
import '../../../providers/gheebat_providers.dart';
import '../../../utils/date_utils_ext.dart';
import '../../../utils/numerals.dart';
import '../charts/progress_ring.dart';

/// Range statistics for the Gheebat tracker: a free-day ring plus the
/// free / slipped / checked-in / rate counts.
class GheebatStatsSection extends ConsumerWidget {
  final DateRange range;

  const GheebatStatsSection({super.key, required this.range});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final useEastern = ref.watch(numeralsProvider);
    final statsAsync = ref.watch(gheebatStatsProvider(range));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: statsAsync.when(
          loading: () => const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Text('$e'),
          data: (stats) => Row(
            children: [
              ProgressRing(
                progress: stats.freePercent,
                size: 108,
                stroke: 10,
                centerTop: '${(stats.freePercent * 100).round()}%',
                centerBottom: l10n.gheebatFreePercentLabel,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StatLine(
                      color: const Color(0xFF1F8F4E),
                      label: l10n.gheebatFreeDaysLabel,
                      value: stats.free,
                      useEastern: useEastern,
                    ),
                    _StatLine(
                      color: const Color(0xFFD9B75B),
                      label: l10n.gheebatSlippedDaysLabel,
                      value: stats.slipped,
                      useEastern: useEastern,
                    ),
                    _StatLine(
                      color: Theme.of(context).colorScheme.outline,
                      label: l10n.gheebatRecordedDaysLabel,
                      value: stats.recorded,
                      useEastern: useEastern,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatLine extends StatelessWidget {
  final Color color;
  final String label;
  final int value;
  final bool useEastern;

  const _StatLine({
    required this.color,
    required this.label,
    required this.value,
    required this.useEastern,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            formatNum(value, useEastern),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
