import 'package:flutter/material.dart';

import '../../../db/app_database.dart';
import '../../../l10n/app_localizations.dart';
import 'timetable_task_tile.dart';

/// Vertical list of the tasks scheduled for one day.
///
/// The blocks are stacked instead of drawn on an hour grid so the timeline
/// stays readable on narrow screens and flips correctly in RTL.
class TimetableTimeline extends StatelessWidget {
  final List<Task> tasks;
  final DateTime day;
  final Set<int> doneIds;
  final bool useEastern;
  final void Function(Task task) onOpenTask;

  const TimetableTimeline({
    super.key,
    required this.tasks,
    required this.day,
    required this.doneIds,
    required this.useEastern,
    required this.onOpenTask,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.timetableResizeHint,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        for (final task in tasks) ...[
          TimetableTaskTile(
            task: task,
            done: doneIds.contains(task.id),
            day: day,
            useEastern: useEastern,
            onOpen: () => onOpenTask(task),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
