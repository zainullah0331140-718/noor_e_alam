import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// One bar in a [SimpleBarChart].
class BarDatum {
  final String label;
  final double value;
  final Color color;
  const BarDatum({
    required this.label,
    required this.value,
    this.color = const Color(0xFF1F8F4E),
  });
}

/// Animated, touch-friendly bar chart used by the month/year views and the
/// dashboard's "last 7 days" panel.
class SimpleBarChart extends StatelessWidget {
  final List<BarDatum> bars;
  final double height;
  final Color? gridColor;
  final bool showValues;
  final String Function(double)? valueFormatter;

  const SimpleBarChart({
    super.key,
    required this.bars,
    this.height = 180,
    this.gridColor,
    this.showValues = false,
    this.valueFormatter,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final maxY = bars.fold<double>(0, (m, b) => b.value > m ? b.value : m);
    final top = maxY <= 0 ? 1.0 : maxY * 1.25;
    final fmt = valueFormatter ?? (v) => v.toStringAsFixed(0);

    return SizedBox(
      height: height,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: top,
          minY: 0,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: top / 4,
            getDrawingHorizontalLine: (_) => FlLine(
              color:
                  gridColor ?? scheme.outlineVariant.withValues(alpha: 0.35),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= bars.length) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      bars[i].label,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => scheme.inverseSurface,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final datum = bars[group.x];
                return BarTooltipItem(
                  '${datum.label}\n${fmt(rod.toY)}',
                  TextStyle(
                    color: scheme.onInverseSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          barGroups: [
            for (var i = 0; i < bars.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: bars[i].value,
                    color: bars[i].color,
                    width: _rodWidth(bars.length),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: top,
                      color: scheme.surfaceContainerHighest.withValues(
                        alpha: 0.5,
                      ),
                    ),
                  ),
                ],
                showingTooltipIndicators: showValues ? const [] : null,
              ),
          ],
        ),
      ),
    );
  }

  double _rodWidth(int count) {
    if (count <= 7) return 18;
    if (count <= 12) return 12;
    return 6;
  }
}
