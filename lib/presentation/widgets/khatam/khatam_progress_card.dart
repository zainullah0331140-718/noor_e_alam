import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../db/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/app_providers.dart';
import '../../../providers/khatam_providers.dart';
import '../../../providers/tilawat_providers.dart';
import '../../../utils/date_utils_ext.dart';
import '../../../utils/numerals.dart';
import '../charts/progress_ring.dart';
import 'khatam_para_grid.dart';

/// Card showing the active Quran khatam: start date, para progress ring,
/// para grid, Tilawat sync and completion actions.
class KhatamProgressCard extends ConsumerWidget {
  const KhatamProgressCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final active = ref.watch(activeKhatamProvider).value;
    if (active == null) {
      return const _EmptyCard();
    }

    final useEastern = ref.watch(numeralsProvider);
    final done =
        ref.watch(khatamDoneParasProvider(active.id)).value ?? const <int>{};
    final position = ref.watch(tilawatPositionProvider).value;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.khatamActiveTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                _InProgressChip(label: l10n.khatamInProgress),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${l10n.khatamStartDate}: '
              '${DateUtilsExt.pretty(DateUtilsExt.parseYmd(active.startDate))}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Center(
              child: ProgressRing(
                progress: done.length / 30,
                centerTop:
                    '${formatNum(done.length, useEastern)}/${formatNum(30, useEastern)}',
                centerBottom: l10n.khatamProgressTitle,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                l10n.khatamParasDone(done.length),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),
            KhatamParaGrid(khatamId: active.id, done: done),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: position == null
                      ? null
                      : () => ref
                            .read(khatamActionsProvider)
                            .syncThrough(
                              active.id,
                              position.para,
                              day: DateTime.now(),
                            ),
                  icon: const Icon(Icons.sync_alt),
                  label: Text(l10n.khatamSyncPosition),
                ),
                FilledButton.icon(
                  onPressed: () =>
                      _confirmComplete(context, ref, active, done.length),
                  icon: const Icon(Icons.check),
                  label: Text(l10n.khatamComplete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmComplete(
    BuildContext context,
    WidgetRef ref,
    Khatam active,
    int doneCount,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.khatamComplete),
        content: Text(l10n.khatamParasDone(doneCount)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancelWord),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.khatamComplete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final now = DateTime.now();
    await ref.read(khatamActionsProvider).complete(active.id, now);
    if (!context.mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.khatamCompletedSnack)));

    final start = DateUtilsExt.parseYmd(active.startDate);
    final days = now.difference(start).inDays + 1;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.khatamCongratsTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.khatamDua),
            const SizedBox(height: 12),
            Text(l10n.khatamDaysTaken(days < 1 ? 1 : days)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.closeWord),
          ),
        ],
      ),
    );
  }
}

class _EmptyCard extends ConsumerWidget {
  const _EmptyCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.khatamNoActive,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () async {
                await ref.read(khatamActionsProvider).start(DateTime.now());
                if (!context.mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.khatamStarted)));
              },
              icon: const Icon(Icons.add),
              label: Text(l10n.khatamStart),
            ),
          ],
        ),
      ),
    );
  }
}

class _InProgressChip extends StatelessWidget {
  final String label;
  const _InProgressChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: scheme.onPrimaryContainer),
      ),
    );
  }
}
