import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/namaz_providers.dart';
import '../charts/calendar_heatmap.dart';

/// Month calendar heatmap bound to [namazMonthProvider]. Tapping a day
/// jumps the day tracker to that date (via the parent callback).
class NamazMonthCalendar extends ConsumerWidget {
  final DateTime month;
  final void Function(DateTime day) onTapDay;

  const NamazMonthCalendar({
    super.key,
    required this.month,
    required this.onTapDay,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final async = ref.watch(namazMonthProvider(month));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '${l10n.rangeMonth} · ${month.year}-${month.month.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            const SizedBox(height: 12),
            async.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text('$e'),
              data: (counts) => CalendarHeatmap(
                month: month,
                countsByDay: counts.map(
                  (k, v) => MapEntry(
                    k,
                    NamazRangeCountsLite(
                      jamaat: v.jamaat,
                      alone: v.alone,
                      missed: v.missed,
                    ),
                  ),
                ),
                onTapDay: onTapDay,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
