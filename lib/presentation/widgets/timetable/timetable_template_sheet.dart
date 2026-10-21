import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/timetable_providers.dart';
import '../../../utils/timetable_templates.dart';

/// Opens the sheet that lists the built-in routines.
Future<void> showTimetableTemplateSheet(
  BuildContext context, {
  required DateTime day,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => TimetableTemplateSheet(day: day),
  );
}

/// Lists the ready-made routines; applying one creates its tasks on [day].
class TimetableTemplateSheet extends ConsumerWidget {
  final DateTime day;

  const TimetableTemplateSheet({super.key, required this.day});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.timetableTemplates,
                  style: theme.textTheme.titleLarge,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
                tooltip: l10n.closeWord,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l10n.timetableTemplatesBody,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          for (final template in timetableTemplates) ...[
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: theme.colorScheme.primaryContainer,
                          foregroundColor: theme.colorScheme.onPrimaryContainer,
                          child: Icon(template.icon, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                templateName(l10n, template.nameKey),
                                style: theme.textTheme.titleSmall,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                templateDescription(
                                  l10n,
                                  template.descriptionKey,
                                ),
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.tonalIcon(
                        onPressed: () => _apply(context, ref, template),
                        icon: const Icon(Icons.add, size: 18),
                        label: Text(l10n.timetableApply),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  Future<void> _apply(
    BuildContext context,
    WidgetRef ref,
    TimetableTemplate template,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final actions = ref.read(timetableActionsProvider);
    for (final task in template.tasks) {
      await actions.addTask(
        TaskDraft(
          title: templateTaskTitle(l10n, task.titleKey),
          category: task.category,
          iconKey: task.iconKey,
          colorValue: task.color.toARGB32(),
          startMinutes: task.startMinutes,
          endMinutes: task.endMinutes,
          repeat: task.repeat,
          weekdaysMask: task.weekdaysMask,
          anchorDate: day,
        ),
      );
    }
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.timetableTemplateApplied)),
    );
  }
}
