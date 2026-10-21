import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../db/app_database.dart';
import '../../db/enums.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../../providers/settings_providers.dart';
import '../../providers/timetable_providers.dart';
import '../../utils/date_utils_ext.dart';
import '../../utils/numerals.dart';
import '../../utils/timetable_templates.dart';
import '../../utils/timetable_utils.dart';
import '../widgets/charts/simple_bar_chart.dart';
import '../widgets/common/date_selector.dart';
import '../widgets/timetable/timetable_task_editor.dart';
import '../widgets/timetable/timetable_task_tile.dart';
import '../widgets/timetable/timetable_template_sheet.dart';
import '../widgets/timetable/timetable_timeline.dart';

/// Daily Timetable module: the tasks of one day, their completion state and
/// the category breakdown.
class TimetableScreen extends ConsumerWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final day = ref.watch(selectedDayProvider);
    final ymd = DateUtilsExt.ymd(day);
    final useEastern = ref.watch(numeralsProvider);
    final today = DateUtilsExt.dateOnly(DateTime.now());
    final isToday = DateUtilsExt.ymd(day) == DateUtilsExt.ymd(today);

    final tasksAsync = ref.watch(timetableTasksProvider);
    final doneAsync = ref.watch(timetableDayProvider(ymd));

    final tasks = tasksAsync.value ?? const <Task>[];
    final doneIds = doneAsync.value ?? const <int>{};

    // Only the tasks that actually occur on the selected day are shown.
    final occurring = tasks
        .where(
          (task) => taskOccursOn(
            repeat: task.repeat,
            weekdaysMask: task.weekdaysMask,
            anchorDate: task.anchorDate,
            day: day,
          ),
        )
        .toList()
      ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));

    final total = occurring.length;
    final done = occurring.where((task) => doneIds.contains(task.id)).length;
    final minutes = totalScheduledMinutes(
      occurring.map((task) => (task.startMinutes, task.endMinutes)),
    );
    final percent = total == 0 ? 0 : (done * 100 / total).round();

    final scheduledByCategory = <TaskCategory, int>{};
    final doneByCategory = <TaskCategory, int>{};
    for (final task in occurring) {
      scheduledByCategory[task.category] =
          (scheduledByCategory[task.category] ?? 0) + 1;
      if (doneIds.contains(task.id)) {
        doneByCategory[task.category] =
            (doneByCategory[task.category] ?? 0) + 1;
      }
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        Row(
          children: [
            Expanded(
              child: DateSelector(
                date: day,
                onChanged: (d) => ref.read(selectedDayProvider.notifier).set(d),
              ),
            ),
            if (!isToday)
              TextButton(
                onPressed: () =>
                    ref.read(selectedDayProvider.notifier).today(),
                child: Text(l10n.rangeToday),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () =>
                    showTimetableTemplateSheet(context, day: day),
                icon: const Icon(Icons.auto_awesome_mosaic_outlined),
                label: Text(l10n.timetableTemplates),
              ),
            ),
            const SizedBox(width: 12),
            IconButton.filled(
              onPressed: () => showTimetableTaskEditor(context, day: day),
              icon: const Icon(Icons.add),
              tooltip: l10n.timetableAddTask,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        isToday
                            ? l10n.timetableTodayTitle
                            : MaterialLocalizations.of(
                                context,
                              ).formatFullDate(day),
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    Text(
                      l10n.timetableCompletion(percent),
                      style: theme.textTheme.labelLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: total == 0 ? 0 : done / total,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _MiniStat(
                        icon: Icons.check_circle_outline,
                        label: l10n.timetableDoneOf(done, total),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MiniStat(
                        icon: Icons.schedule,
                        label: l10n.timetableScheduledMinutes(minutes),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (tasksAsync.isLoading && tasks.isEmpty)
          const Center(child: CircularProgressIndicator())
        else if (total == 0)
          _EmptyState()
        else
          TimetableTimeline(
            tasks: occurring,
            day: day,
            doneIds: doneIds,
            useEastern: useEastern,
            onOpenTask: (task) =>
                showTimetableTaskEditor(context, day: day, task: task),
          ),
        if (total > 0) ...[
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.timetableCategoryLabel,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  SimpleBarChart(
                    height: 160,
                    valueFormatter: (value) =>
                        formatNum(value.round(), useEastern),
                    bars: [
                      for (final category in TaskCategory.values)
                        if ((scheduledByCategory[category] ?? 0) > 0)
                          BarDatum(
                            label: taskCategoryLabel(l10n, category),
                            value:
                                (scheduledByCategory[category] ?? 0).toDouble(),
                            color: taskCategoryColors[category]!,
                          ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final category in TaskCategory.values)
                        if ((scheduledByCategory[category] ?? 0) > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: taskCategoryColors[category]!.withValues(
                                alpha: 0.14,
                              ),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '${taskCategoryLabel(l10n, category)} · '
                              '${l10n.timetableDoneOf(doneByCategory[category] ?? 0, scheduledByCategory[category] ?? 0)}',
                              style: theme.textTheme.labelSmall,
                            ),
                          ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Shown when no task occurs on the selected day.
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.event_available_outlined,
              size: 40,
              color: scheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.timetableNoTasks,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              l10n.timetableNoTasksHint,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Icon + value pair used inside the summary card.
class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MiniStat({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: scheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
