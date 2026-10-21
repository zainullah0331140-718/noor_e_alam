import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/numerals.dart';
import '../charts/donut_chart.dart';

/// Live daily summary bar: donut + J/A/M/Remaining legend. Colours match
/// the spec (Jamaat = green, Alone = gold, Missed = red, Remaining = grey).
class DailySummaryBar extends StatelessWidget {
  final int jamaat;
  final int alone;
  final int missed;
  final int remaining;
  final bool useEastern;

  const DailySummaryBar({
    super.key,
    required this.jamaat,
    required this.alone,
    required this.missed,
    required this.remaining,
    this.useEastern = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final total = jamaat + alone + missed + remaining;
    final prayed = jamaat + alone;
    final pct = prayed == 0 ? 0 : (prayed / (total == 0 ? 1 : total) * 100);
    String n(int v) => formatNum(v, useEastern);

    return Row(
      children: [
        DonutChart(
          size: 108,
          thickness: 16,
          centerTop: '${pct.round()}%',
          centerBottom: l10n.completion,
          slices: [
            DonutSlice(label: l10n.jamaat, value: jamaat.toDouble(), color: const Color(0xFF1F8F4E)),
            DonutSlice(label: l10n.alone, value: alone.toDouble(), color: const Color(0xFFD9B75B)),
            DonutSlice(label: l10n.missed, value: missed.toDouble(), color: const Color(0xFFD32F2F)),
            DonutSlice(label: l10n.remaining, value: remaining.toDouble(), color: scheme.surfaceContainerHighest),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.summaryLine(jamaat, alone, missed, remaining),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 10),
              _Legend(color: const Color(0xFF1F8F4E), label: l10n.jamaat, value: n(jamaat)),
              _Legend(color: const Color(0xFFD9B75B), label: l10n.alone, value: n(alone)),
              _Legend(color: const Color(0xFFD32F2F), label: l10n.missed, value: n(missed)),
              _Legend(color: scheme.outline, label: l10n.remaining, value: n(remaining)),
            ],
          ),
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  const _Legend({required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
