import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../db/enums.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/app_providers.dart';
import '../../../providers/tilawat_providers.dart';
import '../../../utils/date_utils_ext.dart';
import '../../../utils/numerals.dart';
import 'tilawat_position_card.dart' show tilawatUnitLabel;

/// Per-day Tilawat log list showing amount, unit and note for each entry.
class TilawatEntryList extends ConsumerWidget {
  final DateTime date;

  const TilawatEntryList({super.key, required this.date});

  IconData _iconFor(TilawatUnit unit) {
    switch (unit) {
      case TilawatUnit.pages:
        return Icons.menu_book_outlined;
      case TilawatUnit.ruku:
        return Icons.format_list_numbered;
      case TilawatUnit.para:
        return Icons.bookmark_outline;
      case TilawatUnit.minutes:
        return Icons.timer_outlined;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final useEastern = ref.watch(numeralsProvider);
    final entriesAsync = ref.watch(tilawatDayProvider(DateUtilsExt.ymd(date)));

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: entriesAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) =>
              Padding(padding: const EdgeInsets.all(16), child: Text('$e')),
          data: (entries) {
            if (entries.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Text(l10n.noData),
              );
            }
            return Column(
              children: [
                for (final e in entries)
                  ListTile(
                    dense: true,
                    leading: Icon(_iconFor(e.unit), color: scheme.primary),
                    title: Text(
                      '${formatNum(e.amount, useEastern)} '
                      '${tilawatUnitLabel(l10n, e.unit)}',
                    ),
                    subtitle: (e.note == null || e.note!.isEmpty)
                        ? null
                        : Text(e.note!),
                    trailing: IconButton(
                      tooltip: l10n.deleteWord,
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        await ref
                            .read(tilawatActionsProvider)
                            .deleteEntry(e.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.tilawatEntryDeleted)),
                          );
                        }
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
