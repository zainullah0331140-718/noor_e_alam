import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../db/enums.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/app_providers.dart';
import '../../../providers/tilawat_providers.dart';
import '../../../utils/numerals.dart';

/// Saved Quran reading position (para / surah / page) with edit dialog.
class TilawatPositionCard extends ConsumerWidget {
  const TilawatPositionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final useEastern = ref.watch(numeralsProvider);
    final posAsync = ref.watch(tilawatPositionProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: posAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('$e'),
          data: (pos) {
            if (pos == null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.tilawatPositionTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.noData,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: FilledButton.tonal(
                      onPressed: () => _showEditDialog(context, ref),
                      child: Text(l10n.tilawatUpdatePosition),
                    ),
                  ),
                ],
              );
            }
            final scheme = Theme.of(context).colorScheme;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.tilawatPositionTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                _PositionLine(
                  label: l10n.tilawatParaLabel,
                  value: formatNum(pos.para, useEastern),
                ),
                _PositionLine(label: l10n.tilawatSurahLabel, value: pos.surah),
                _PositionLine(
                  label: l10n.tilawatPageLabel,
                  value: formatNum(pos.page, useEastern),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: scheme.surfaceContainerHighest.withValues(
                      alpha: 0.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.tilawatContinue,
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall?.copyWith(color: scheme.primary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${l10n.tilawatParaLabel} ${formatNum(pos.para, useEastern)}'
                        ' · ${pos.surah}'
                        ' · ${l10n.tilawatPageLabel} ${formatNum(pos.page, useEastern)}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: FilledButton.tonal(
                    onPressed: () => _showEditDialog(context, ref),
                    child: Text(l10n.tilawatUpdatePosition),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final actions = ref.read(tilawatActionsProvider);
    final pos = ref.read(tilawatPositionProvider).value;
    final formKey = GlobalKey<FormState>();
    final paraController = TextEditingController(
      text: pos == null ? '' : '${pos.para}',
    );
    final surahController = TextEditingController(text: pos?.surah ?? '');
    final pageController = TextEditingController(
      text: pos == null ? '' : '${pos.page}',
    );

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.tilawatPositionTitle),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: paraController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l10n.tilawatParaLabel),
                validator: (v) {
                  final n = int.tryParse((v ?? '').trim());
                  if (n == null || n < 1 || n > 30) {
                    return l10n.tilawatAmountInvalid;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: surahController,
                decoration: InputDecoration(labelText: l10n.tilawatSurahLabel),
                validator: (v) =>
                    (v ?? '').trim().isEmpty ? l10n.tilawatAmountInvalid : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: pageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l10n.tilawatPageLabel),
                validator: (v) {
                  final n = int.tryParse((v ?? '').trim());
                  if (n == null || n < 1) return l10n.tilawatAmountInvalid;
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancelWord),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(ctx).pop(true);
              }
            },
            child: Text(l10n.saveWord),
          ),
        ],
      ),
    );

    if (saved == true) {
      await actions.savePosition(
        para: int.parse(paraController.text.trim()),
        surah: surahController.text.trim(),
        page: int.parse(pageController.text.trim()),
      );
      ref.invalidate(tilawatPositionProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.tilawatPositionSaved)));
      }
    }
    paraController.dispose();
    surahController.dispose();
    pageController.dispose();
  }
}

class _PositionLine extends StatelessWidget {
  final String label;
  final String value;
  const _PositionLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(width: 8),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

/// Localized label for a recitation unit, shared by the Tilawat widgets.
String tilawatUnitLabel(AppLocalizations l10n, TilawatUnit unit) {
  switch (unit) {
    case TilawatUnit.pages:
      return l10n.unitPages;
    case TilawatUnit.ruku:
      return l10n.unitRuku;
    case TilawatUnit.para:
      return l10n.unitPara;
    case TilawatUnit.minutes:
      return l10n.unitMinutes;
  }
}
