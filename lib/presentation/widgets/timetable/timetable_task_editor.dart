import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../db/app_database.dart';
import '../../../db/enums.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/app_providers.dart';
import '../../../providers/timetable_providers.dart';
import '../../../utils/date_utils_ext.dart';
import '../../../utils/timetable_templates.dart';
import '../../../utils/timetable_utils.dart';
import 'timetable_task_tile.dart';

/// Opens the add / edit sheet for a timetable task.
///
/// [task] is null when a new task is created; the new task is anchored on
/// [day] so it shows up on the day the user is looking at.
Future<void> showTimetableTaskEditor(
  BuildContext context, {
  required DateTime day,
  Task? task,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => TimetableTaskEditor(day: day, task: task),
  );
}

/// Form used to create and to edit a task.
class TimetableTaskEditor extends ConsumerStatefulWidget {
  final DateTime day;
  final Task? task;

  const TimetableTaskEditor({super.key, required this.day, this.task});

  @override
  ConsumerState<TimetableTaskEditor> createState() =>
      _TimetableTaskEditorState();
}

class _TimetableTaskEditorState extends ConsumerState<TimetableTaskEditor> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _noteController;
  late DateTime _anchorDate;
  late TaskCategory _category;
  late String _iconKey;
  late int _colorValue;
  late int _startMinutes;
  late int _endMinutes;
  late TaskRepeat _repeat;
  late int _weekdaysMask;
  int? _reminderMinutes;
  bool _busy = false;

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    if (task == null) {
      _titleController = TextEditingController();
      _noteController = TextEditingController();
      _anchorDate = DateUtilsExt.dateOnly(widget.day);
      _category = TaskCategory.ibadah;
      _iconKey = 'task';
      _colorValue = taskCategoryColors[TaskCategory.ibadah]!.toARGB32();
      _startMinutes = 9 * 60;
      _endMinutes = 10 * 60;
      _repeat = TaskRepeat.daily;
      _weekdaysMask = 0x7F;
      _reminderMinutes = null;
    } else {
      _titleController = TextEditingController(text: task.title);
      _noteController = TextEditingController(text: task.note ?? '');
      _anchorDate = DateUtilsExt.parseYmd(task.anchorDate);
      _category = task.category;
      _iconKey = task.iconKey;
      _colorValue = task.colorValue;
      _startMinutes = task.startMinutes;
      _endMinutes = task.endMinutes;
      _repeat = task.repeat;
      _weekdaysMask = task.weekdaysMask;
      _reminderMinutes = task.reminderMinutes;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  /// Localized short weekday name (Monday = 0, matching [weekdayIndex]).
  String _weekdayLabel(AppLocalizations l10n, int index) {
    switch (index) {
      case 0:
        return l10n.weekdayMon;
      case 1:
        return l10n.weekdayTue;
      case 2:
        return l10n.weekdayWed;
      case 3:
        return l10n.weekdayThu;
      case 4:
        return l10n.weekdayFri;
      case 5:
        return l10n.weekdaySat;
      default:
        return l10n.weekdaySun;
    }
  }

  void _selectCategory(TaskCategory category) {
    setState(() {
      _category = category;
      _colorValue = taskCategoryColors[category]!.toARGB32();
    });
  }

  Future<void> _pickStart() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: _startMinutes ~/ 60,
        minute: _startMinutes % 60,
      ),
    );
    if (picked == null || !mounted) return;
    final minutes = picked.hour * 60 + picked.minute;
    final (start, end) = clampTaskRange(minutes, _endMinutes);
    setState(() {
      _startMinutes = start;
      _endMinutes = end;
    });
  }

  Future<void> _pickEnd() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: _endMinutes ~/ 60,
        minute: _endMinutes % 60,
      ),
    );
    if (picked == null || !mounted) return;
    final minutes = picked.hour * 60 + picked.minute;
    final (start, end) = clampTaskRange(_startMinutes, minutes);
    setState(() {
      _startMinutes = start;
      _endMinutes = end;
    });
  }

  Future<void> _pickReminder() async {
    final current = _reminderMinutes ?? _startMinutes;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: current ~/ 60, minute: current % 60),
    );
    if (picked == null || !mounted) return;
    setState(() => _reminderMinutes = picked.hour * 60 + picked.minute);
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _busy = true);
    final draft = TaskDraft(
      title: _titleController.text.trim(),
      category: _category,
      iconKey: _iconKey,
      colorValue: _colorValue,
      startMinutes: _startMinutes,
      endMinutes: _endMinutes,
      repeat: _repeat,
      weekdaysMask: _weekdaysMask,
      anchorDate: _anchorDate,
      reminderMinutes: _reminderMinutes,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );
    final actions = ref.read(timetableActionsProvider);
    try {
      if (_isEditing) {
        await actions.updateTask(widget.task!.id, draft);
      } else {
        await actions.addTask(draft);
      }
    } catch (_) {
      if (mounted) setState(() => _busy = false);
      return;
    }
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    Navigator.of(context).pop();
    messenger.showSnackBar(SnackBar(content: Text(l10n.timetableTaskSaved)));
  }

  Future<void> _confirmDelete() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        content: Text(l10n.timetableDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancelWord),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.deleteWord),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _busy = true);
    try {
      await ref.read(timetableActionsProvider).deleteTask(widget.task!.id);
    } catch (_) {
      if (mounted) setState(() => _busy = false);
      return;
    }
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(SnackBar(content: Text(l10n.timetableTaskDeleted)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final useEastern = ref.watch(numeralsProvider);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _isEditing
                          ? l10n.timetableEditTask
                          : l10n.timetableAddTask,
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
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: l10n.timetableTaskTitle,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? l10n.tilawatAmountInvalid
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.timetableCategoryLabel,
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final category in TaskCategory.values)
                    ChoiceChip(
                      selected: _category == category,
                      avatar: CircleAvatar(
                        radius: 7,
                        backgroundColor: taskCategoryColors[category],
                      ),
                      label: Text(taskCategoryLabel(l10n, category)),
                      onSelected: (_) => _selectCategory(category),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(l10n.timetableIconLabel, style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final entry in taskIconOptions.entries)
                    _IconOption(
                      icon: entry.value,
                      selected: _iconKey == entry.key,
                      onTap: () => setState(() => _iconKey = entry.key),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(l10n.timetableColorLabel, style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final color in taskCategoryColors.values)
                    _ColorOption(
                      color: color,
                      selected: _colorValue == color.toARGB32(),
                      onTap: () =>
                          setState(() => _colorValue = color.toARGB32()),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _TimeField(
                      label: l10n.timetableStartTime,
                      icon: Icons.play_arrow,
                      value: clockText(context, _startMinutes, useEastern),
                      onTap: _pickStart,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TimeField(
                      label: l10n.timetableEndTime,
                      icon: Icons.stop,
                      value: clockText(context, _endMinutes, useEastern),
                      onTap: _pickEnd,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TaskRepeat>(
                initialValue: _repeat,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: l10n.timetableRepeatLabel,
                  border: const OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(
                    value: TaskRepeat.once,
                    child: Text(l10n.repeatOnce),
                  ),
                  DropdownMenuItem(
                    value: TaskRepeat.daily,
                    child: Text(l10n.repeatDaily),
                  ),
                  DropdownMenuItem(
                    value: TaskRepeat.weekdays,
                    child: Text(l10n.repeatWeekdays),
                  ),
                  DropdownMenuItem(
                    value: TaskRepeat.customDays,
                    child: Text(l10n.repeatCustomDays),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _repeat = value;
                    if (value == TaskRepeat.customDays && _weekdaysMask == 0) {
                      _weekdaysMask = weekdayMaskFromSet({
                        DateTime.now().weekday - 1,
                      });
                    }
                  });
                },
              ),
              if (_repeat == TaskRepeat.customDays) ...[
                const SizedBox(height: 16),
                Text(
                  l10n.repeatPickDays,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (var day = 0; day < 7; day++)
                      FilterChip(
                        selected: _weekdaysMask & (1 << day) != 0,
                        label: Text(_weekdayLabel(l10n, day)),
                        onSelected: (selected) {
                          final days = weekdaySetFromMask(_weekdaysMask);
                          if (selected) {
                            days.add(day);
                          } else {
                            days.remove(day);
                          }
                          setState(() => _weekdaysMask = weekdayMaskFromSet(days));
                        },
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.timetableReminderLabel,
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                  if (_reminderMinutes != null)
                    TextButton.icon(
                      onPressed: _pickReminder,
                      icon: const Icon(Icons.alarm, size: 18),
                      label: Text(
                        clockText(context, _reminderMinutes!, useEastern),
                      ),
                    ),
                  Switch(
                    value: _reminderMinutes != null,
                    onChanged: (value) => setState(() {
                      _reminderMinutes = value
                          ? (_startMinutes > 10 ? _startMinutes - 10 : 0)
                          : null;
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _noteController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: l10n.timetableNoteLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  if (_isEditing) ...[
                    OutlinedButton.icon(
                      onPressed: _busy ? null : _confirmDelete,
                      icon: const Icon(Icons.delete_outline),
                      label: Text(l10n.deleteWord),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.error,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: FilledButton(
                      onPressed: _busy ? null : _save,
                      child: Text(l10n.saveWord),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Labelled time picker field used for the start and end of a task.
class _TimeField extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final VoidCallback onTap;

  const _TimeField({
    required this.label,
    required this.icon,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onTap,
            icon: Icon(icon, size: 18),
            label: Text(value),
          ),
        ),
      ],
    );
  }
}

/// Selectable icon in the editor.
class _IconOption extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _IconOption({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? scheme.primaryContainer
              : scheme.surfaceContainerHighest.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? scheme.primary : scheme.outlineVariant,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: selected ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// Selectable colour swatch in the editor.
class _ColorOption extends StatelessWidget {
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _ColorOption({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? scheme.onSurface : Colors.transparent,
            width: 3,
          ),
        ),
        child: selected
            ? const Icon(Icons.check, size: 18, color: Colors.white)
            : null,
      ),
    );
  }
}
