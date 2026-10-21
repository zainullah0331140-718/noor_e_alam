import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/app_providers.dart';
import '../../../utils/date_utils_ext.dart';

/// Previous/next arrows + tappable date that opens a calendar picker.
class DateSelector extends ConsumerWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const DateSelector({
    super.key,
    required this.date,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final today = DateUtilsExt.dateOnly(DateTime.now());
    final isToday = DateUtilsExt.ymd(date) == DateUtilsExt.ymd(today);

    return Row(
      children: [
        IconButton(
          tooltip: l10n.previousDay,
          onPressed: () =>
              onChanged(date.subtract(const Duration(days: 1))),
          icon: const Icon(Icons.chevron_left),
        ),
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: firstDate ?? DateTime(2020),
                lastDate: lastDate ?? today,
              );
              if (picked != null) onChanged(picked);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 16, color: scheme.primary),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      isToday
                          ? '${l10n.rangeToday} · ${DateUtilsExt.pretty(date)}'
                          : DateUtilsExt.pretty(date),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        IconButton(
          tooltip: l10n.nextDay,
          onPressed: date.isBefore(today) || DateUtilsExt.ymd(date) == DateUtilsExt.ymd(today)
              ? () => onChanged(date.add(const Duration(days: 1)))
              : null,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

/// Segmented Today / Month / Year toggle bound to [dashboardRangeProvider].
class RangeToggle extends ConsumerWidget {
  const RangeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final current = ref.watch(dashboardRangeProvider);
    return SegmentedButton<DashboardRange>(
      showSelectedIcon: false,
      segments: [
        ButtonSegment(value: DashboardRange.today, label: Text(l10n.rangeToday)),
        ButtonSegment(value: DashboardRange.month, label: Text(l10n.rangeMonth)),
        ButtonSegment(value: DashboardRange.year, label: Text(l10n.rangeYear)),
      ],
      selected: {current},
      onSelectionChanged: (set) =>
          ref.read(dashboardRangeProvider.notifier).set(set.first),
    );
  }
}
