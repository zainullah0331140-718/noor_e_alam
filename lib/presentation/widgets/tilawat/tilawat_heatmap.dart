import 'package:flutter/material.dart';

import '../../../db/daos/tilawat_dao.dart';
import '../../../db/enums.dart';
import '../../../utils/date_utils_ext.dart';

/// Monday-first month heatmap coloured by recitation intensity for a unit.
class TilawatHeatmap extends StatelessWidget {
  final DateTime month;
  final Map<String, TilawatDayTotals> totals;
  final TilawatUnit unit;

  const TilawatHeatmap({
    super.key,
    required this.month,
    required this.totals,
    required this.unit,
  });

  static const _weekdayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final first = DateTime(month.year, month.month, 1);
    final leading = (first.weekday - 1) % 7;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    var maxAmount = 1;
    for (final t in totals.values) {
      final amount = t.amountFor(unit);
      if (amount > maxAmount) maxAmount = amount;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (final label in _weekdayLabels)
              Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
          ],
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
            final amount = totals[DateUtilsExt.ymd(date)]?.amountFor(unit) ?? 0;
            final intensity = amount == 0
                ? 0.0
                : (amount / maxAmount).clamp(0.0, 1.0);
            final color = amount == 0
                ? scheme.surfaceContainerHighest
                : scheme.primary.withValues(alpha: 0.15 + 0.75 * intensity);
            final isToday =
                date.year == now.year &&
                date.month == now.month &&
                date.day == now.day;
            return _TilawatDayCell(
              day: day,
              color: color,
              strong: intensity > 0.5,
              highlighted: isToday,
            );
          },
        ),
      ],
    );
  }
}

class _TilawatDayCell extends StatelessWidget {
  final int day;
  final Color color;
  final bool strong;
  final bool highlighted;

  const _TilawatDayCell({
    required this.day,
    required this.color,
    required this.strong,
    required this.highlighted,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
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
          color: strong ? Colors.white : scheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
