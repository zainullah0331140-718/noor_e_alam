import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../charts/donut_chart.dart';

/// A dashboard donut card: title, animated donut, detail line and an
/// optional colourful sub-line (e.g. the Namaz J/A/M breakdown).
class DashboardDonutCard extends StatelessWidget {
  final String title;
  final String detail;
  final String? subtitle;
  final double completion; // 0..1
  final List<DonutSlice> slices;
  final IconData icon;
  final Color accent;
  final bool useEastern;
  final VoidCallback? onTap;

  const DashboardDonutCard({
    super.key,
    required this.title,
    required this.detail,
    required this.completion,
    required this.slices,
    required this.icon,
    required this.accent,
    this.subtitle,
    this.useEastern = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 18, color: accent),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Center(
                child: DonutChart(
                  size: 96,
                  thickness: 13,
                  centerTop: '${(completion * 100).round()}%',
                  centerBottom: l10n.completion,
                  slices: slices,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                detail,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
