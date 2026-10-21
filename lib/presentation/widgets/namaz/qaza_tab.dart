import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../db/app_database.dart';
import '../../../db/enums.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/app_providers.dart';
import '../../../providers/qaza_providers.dart';
import '../../../utils/numerals.dart';
import '../prayer_labels.dart';

/// Qaza manager: pending counters per prayer, manual add, make-up action
/// and a history log of made-up qaza.
class QazaTab extends ConsumerWidget {
  const QazaTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final pending = ref.watch(qazaPendingProvider);
    final history = ref.watch(qazaHistoryProvider);
    final useEastern = ref.watch(numeralsProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.qazaPendingTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            FilledButton.tonalIcon(
              onPressed: () => _showAddDialog(context, ref),
              icon: const Icon(Icons.add, size: 18),
              label: Text(l10n.qazaAddManual),
            ),
          ],
        ),
        const SizedBox(height: 12),
        pending.when(
          loading: () => const _Loading(),
          error: (e, _) => Text('$e'),
          data: (counts) {
            final anyPending = counts.values.any((v) => v > 0);
            if (!anyPending) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(l10n.qazaNoPending)),
                    ],
                  ),
                ),
              );
            }
            return Column(
              children: [
                for (final type in NamazType.values)
                  if ((counts[type] ?? 0) > 0) ...[
                    _PendingRow(
                      type: type,
                      count: counts[type] ?? 0,
                      useEastern: useEastern,
                      onClear: () => _clearOne(context, ref, type),
                    ),
                    const SizedBox(height: 8),
                  ],
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        Text(
          l10n.qazaHistoryTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        history.when(
          loading: () => const _Loading(),
          error: (e, _) => Text('$e'),
          data: (records) {
            final madeUp = records.where((r) => r.isMadeUp).toList();
            if (madeUp.isEmpty) {
              return Text(
                l10n.noData,
                style: Theme.of(context).textTheme.bodySmall,
              );
            }
            return Column(
              children: [
                for (final r in madeUp) _HistoryRow(record: r),
              ],
            );
          },
        ),
      ],
    );
  }

  Future<void> _clearOne(
    BuildContext context,
    WidgetRef ref,
    NamazType type,
  ) async {
    await ref.read(qazaActionsProvider).clearOneRakat(type);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.qazaCleared)),
      );
    }
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    var prayer = NamazType.fajr;
    var rakats = 1;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.qazaAddDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<NamazType>(
                initialValue: prayer,
                decoration: InputDecoration(labelText: l10n.moduleNamaz),
                items: [
                  for (final t in NamazType.values)
                    DropdownMenuItem(
                      value: t,
                      child: Text(PrayerLabels.namaz(l10n, t)),
                    ),
                ],
                onChanged: (v) => setState(() => prayer = v ?? prayer),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: Text(l10n.qazaRakatsLabel)),
                  IconButton(
                    onPressed: rakats > 1
                        ? () => setState(() => rakats--)
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text('$rakats',
                      style: Theme.of(context).textTheme.titleMedium),
                  IconButton(
                    onPressed: () => setState(() => rakats++),
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.backToDashboard),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.qazaAddManual),
            ),
          ],
        ),
      ),
    );
    if (result == true) {
      await ref
          .read(qazaActionsProvider)
          .addManual(prayer: prayer, rakats: rakats);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.qazaAdded)),
        );
      }
    }
  }
}

class _PendingRow extends StatelessWidget {
  final NamazType type;
  final int count;
  final bool useEastern;
  final VoidCallback onClear;

  const _PendingRow({
    required this.type,
    required this.count,
    required this.useEastern,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: scheme.errorContainer,
              child: Text(
                formatNum(count, useEastern),
                style: TextStyle(
                  color: scheme.onErrorContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    PrayerLabels.namaz(l10n, type),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    '${formatNum(count, useEastern)} ${l10n.pendingWord}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: onClear,
              child: Text(l10n.qazaMarkMadeUp),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  final QazaRecord record;
  const _HistoryRow({required this.record});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        record.source == 'manual' ? Icons.edit_note : Icons.autorenew,
        color: scheme.primary,
      ),
      title: Text(PrayerLabels.namaz(l10n, record.prayer)),
      subtitle: Text(
        '${l10n.rakatsCount(record.rakats)} · '
        '${record.madeUpDate ?? ''}'
        '${record.source == 'manual' ? ' · ${l10n.qazaAddManual}' : ''}',
      ),
      trailing: Icon(Icons.check, color: scheme.primary, size: 18),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
