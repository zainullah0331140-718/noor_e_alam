import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/app_providers.dart';
import '../../../providers/muraqaba_providers.dart';
import '../../../utils/date_utils_ext.dart';
import '../../../utils/numerals.dart';

/// Monday-first month heatmap coloured by the minutes practised each day.
class MuraqabaHeatmap extends ConsumerWidget {
  final DateTime month;
  final DateRange range;

  const MuraqabaHeatmap({
    super.key,
    required this.month,
    required this.range,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final useEastern = ref.watch(numeralsProvider);
    final minutesAsync = ref.watch(muraqabaMinutesByDayProvider(range));

    final first = DateTime(month.year, month.month, 1);
    final leading = (first.weekday - 1) % 7;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final now = DateTime.now();
    final weekdayLabels = [
      l10n.weekdayMon,
      l10n.weekdayTue,
      l10n.weekdayWed,
      l10n.weekdayThu,
      l10n.weekdayFri,
      l10n.weekdaySat,
      l10n.weekdaySun,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (final label in weekdayLabels)
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
        minutesAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Text('$e'),
          data: (minutesByDay) => GridView.builder(
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
              final minutes = minutesByDay[DateUtilsExt.ymd(date)] ?? 0;
              final isToday =
                  date.year == now.year &&
                  date.month == now.month &&
                  date.day == now.day;
              return _MuraqabaDayCell(
                day: formatNum(day, useEastern),
                minutes: minutes,
                highlighted: isToday,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MuraqabaDayCell extends StatelessWidget {
  final String day;
  final int minutes;
  final bool highlighted;

  const _MuraqabaDayCell({
    required this.day,
    required this.minutes,
    required this.highlighted,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final Color background;
    final Color foreground;
    if (minutes <= 0) {
      background = scheme.outlineVariant;
      foreground = scheme.onSurface;
    } else if (minutes <= 10) {
      background = scheme.primary.withValues(alpha: 0.25);
      foreground = scheme.onSurface;
    } else if (minutes <= 20) {
      background = scheme.primary.withValues(alpha: 0.6);
      foreground = scheme.onPrimary;
    } else {
      background = scheme.primary;
      foreground = scheme.onPrimary;
    }

    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
        border: highlighted
            ? Border.all(color: scheme.primary, width: 2)
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        day,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
