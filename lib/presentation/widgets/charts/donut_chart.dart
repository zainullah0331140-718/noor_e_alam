import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// One slice of a [DonutChart].
class DonutSlice {
  final String label;
  final double value;
  final Color color;
  const DonutSlice({
    required this.label,
    required this.value,
    required this.color,
  });
}

/// Animated donut chart with an optional centre label.
///
/// Used by the Namaz summary bar (Jamaat/Alone/Missed/Remaining), the
/// dashboard cards and the nafl per-type breakdown.
class DonutChart extends StatelessWidget {
  final List<DonutSlice> slices;
  final double size;
  final double thickness;
  final String? centerTop;
  final String? centerBottom;
  final Duration duration;

  const DonutChart({
    super.key,
    required this.slices,
    this.size = 120,
    this.thickness = 20,
    this.centerTop,
    this.centerBottom,
    this.duration = const Duration(milliseconds: 650),
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final visible = slices.where((s) => s.value > 0).toList();
    final total = slices.fold<double>(0, (sum, s) => sum + s.value);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: total == 0 ? 1 : 1),
            duration: duration,
            curve: Curves.easeOutCubic,
            builder: (context, t, _) {
              return PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: size / 2 - thickness,
                  startDegreeOffset: -90,
                  sections: total == 0
                      ? [
                          PieChartSectionData(
                            value: 1,
                            color: scheme.surfaceContainerHighest,
                            showTitle: false,
                            radius: thickness,
                          ),
                        ]
                      : visible
                            .map(
                              (s) => PieChartSectionData(
                                value: s.value * t,
                                color: s.color,
                                showTitle: false,
                                radius: thickness,
                              ),
                            )
                            .toList(),
                ),
              );
            },
          ),
          if (centerTop != null || centerBottom != null)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (centerTop != null)
                  Text(
                    centerTop!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: scheme.onSurface,
                    ),
                  ),
                if (centerBottom != null)
                  Text(
                    centerBottom!,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
