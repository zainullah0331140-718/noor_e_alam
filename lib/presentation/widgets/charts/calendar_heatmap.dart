import 'package:flutter/material.dart';

import '../../../db/enums.dart';

/// Colour a single day's performance (used by the month heatmap and dots).
///
/// Rules:
///  · all fard prayers jamaat  → dark green
///  · all fard prayers prayed  → green
///  · any missed, some prayed  → gold (mixed)
///  · only missed / nothing    → red
///  · no data at all           → grey track
Color heatmapColorFor({
  required int jamaat,
  required int alone,
  required int missed,
  required Color trackColor,
  required bool isDark,
}) {
  final prayed = jamaat + alone;
  if (prayed == 0 && missed == 0) return trackColor;
  if (missed == 0 && jamaat == prayed) {
    return isDark ? const Color(0xFF2E7D32) : const Color(0xFF1B5E20);
  }
  if (missed == 0) {
    return isDark ? const Color(0xFF43A047) : const Color(0xFF4CAF50);
  }
  if (prayed == 0) {
    return isDark ? const Color(0xFFC62828) : const Color(0xFFD32F2F);
  }
  return isDark ? const Color(0xFFC79A2E) : const Color(0xFFD9B75B);
}

/// Compact month calendar heatmap: one cell per day, coloured by the
/// day's J/A/M tally. Tapping a day invokes [onTapDay].
class CalendarHeatmap extends StatelessWidget {
  final DateTime month;
  final Map<String, NamazRangeCountsLite> countsByDay;
  final void Function(DateTime day)? onTapDay;

  const CalendarHeatmap({
    super.key,
    required this.month,
    required this.countsByDay,
    this.onTapDay,
  });

  static const _weekdayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final first = DateTime(month.year, month.month, 1);
    // Monday-first grid offset.
    final leading = (first.weekday - 1) % 7;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: _weekdayLabels
              .map(
                (l) => Expanded(
                  child: Center(
                    child: Text(
                      l,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 6),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: leading + daysInMonth,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            if (index < leading) return const SizedBox.shrink();
            final day = index - leading + 1;
            final date = DateTime(month.year, month.month, day);
            final key = _ymd(date);
            final c = countsByDay[key];
            final color = heatmapColorFor(
              jamaat: c?.jamaat ?? 0,
              alone: c?.alone ?? 0,
              missed: c?.missed ?? 0,
              trackColor: scheme.surfaceContainerHighest,
              isDark: isDark,
            );
            final isToday = _isToday(date);
            return _HeatCell(
              day: day,
              color: color,
              highlighted: isToday,
              onTap: onTapDay == null ? null : () => onTapDay!(date),
            );
          },
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 14,
          runSpacing: 6,
          children: [
            _LegendDot(
              color: heatmapColorFor(
                jamaat: 5,
                alone: 0,
                missed: 0,
                trackColor: scheme.surfaceContainerHighest,
                isDark: isDark,
              ),
              label: 'All Jamaat',
            ),
            _LegendDot(
              color: heatmapColorFor(
                jamaat: 3,
                alone: 0,
                missed: 1,
                trackColor: scheme.surfaceContainerHighest,
                isDark: isDark,
              ),
              label: 'Mixed',
            ),
            _LegendDot(
              color: heatmapColorFor(
                jamaat: 0,
                alone: 0,
                missed: 5,
                trackColor: scheme.surfaceContainerHighest,
                isDark: isDark,
              ),
              label: 'Missed',
            ),
          ],
        ),
      ],
    );
  }

  static String _ymd(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static bool _isToday(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }
}

class _HeatCell extends StatelessWidget {
  final int day;
  final Color color;
  final bool highlighted;
  final VoidCallback? onTap;

  const _HeatCell({
    required this.day,
    required this.color,
    required this.highlighted,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: highlighted
              ? Border.all(color: scheme.primary, width: 2)
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          '$day',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.95),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

/// Lightweight day tally consumed by the heatmap (avoids importing the DAO
/// layer into presentation code).
class NamazRangeCountsLite {
  final int jamaat;
  final int alone;
  final int missed;
  const NamazRangeCountsLite({
    required this.jamaat,
    required this.alone,
    required this.missed,
  });
}

/// Convenience mapping helper from a live DB row's enums.
extension NamazStatusCounts on NamazStatus {
  bool get isPrayed => this == NamazStatus.jamaat || this == NamazStatus.alone;
}
