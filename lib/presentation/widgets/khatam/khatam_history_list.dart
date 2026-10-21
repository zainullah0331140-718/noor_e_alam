import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../db/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/khatam_providers.dart';
import '../../../utils/date_utils_ext.dart';

/// History of all khatam cycles (newest first), newest active flagged.
class KhatamHistoryList extends ConsumerWidget {
  const KhatamHistoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final khatamsAsync = ref.watch(khatamsProvider);

    return khatamsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Text('$e'),
      data: (khatams) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.khatamHistoryTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                if (khatams.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      l10n.khatamNoHistory,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  )
                else
                  for (var i = 0; i < khatams.length; i++) ...[
                    _HistoryTile(l10n: l10n, khatam: khatams[i]),
                    if (i < khatams.length - 1) const Divider(height: 1),
                  ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final AppLocalizations l10n;
  final Khatam khatam;
  const _HistoryTile({required this.l10n, required this.khatam});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final start = DateUtilsExt.parseYmd(khatam.startDate);
    final endYmd = khatam.endDate;
    final subtitle = endYmd == null
        ? l10n.khatamInProgress
        : '${l10n.khatamEndDate}: ${DateUtilsExt.pretty(DateUtilsExt.parseYmd(endYmd))}'
              ' · ${l10n.khatamDaysTaken(_days(start, DateUtilsExt.parseYmd(endYmd)))}';

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: scheme.primaryContainer,
        child: Icon(
          Icons.auto_stories,
          size: 20,
          color: scheme.onPrimaryContainer,
        ),
      ),
      title: Text(
        '${l10n.khatamStartDate}: ${DateUtilsExt.pretty(start)}',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
      trailing: endYmd == null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                l10n.khatamInProgress,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: scheme.onPrimaryContainer,
                ),
              ),
            )
          : Icon(Icons.check_circle, color: scheme.primary),
    );
  }

  int _days(DateTime start, DateTime end) {
    final days = end.difference(start).inDays + 1;
    return days < 1 ? 1 : days;
  }
}
