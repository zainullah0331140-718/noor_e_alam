import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/app_providers.dart';

/// Compact Today / Month / Year segmented toggle used inside stats and
/// dashboard panels. Delegates to [dashboardRangeProvider] so the whole app
/// stays in sync.
class MonthYearToggle extends ConsumerWidget {
  const MonthYearToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final current = ref.watch(dashboardRangeProvider);
    return SegmentedButton<DashboardRange>(
      showSelectedIcon: false,
      segments: [
        ButtonSegment(
          value: DashboardRange.today,
          label: Text(l10n.rangeToday),
        ),
        ButtonSegment(
          value: DashboardRange.month,
          label: Text(l10n.rangeMonth),
        ),
        ButtonSegment(
          value: DashboardRange.year,
          label: Text(l10n.rangeYear),
        ),
      ],
      selected: {current},
      onSelectionChanged: (set) =>
          ref.read(dashboardRangeProvider.notifier).set(set.first),
    );
  }
}
