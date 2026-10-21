import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../db/app_database.dart';
import '../../../db/enums.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/timetable_providers.dart';
import '../../../utils/date_utils_ext.dart';
import '../../../utils/numerals.dart';
import '../../../utils/timetable_templates.dart';
import '../../../utils/timetable_utils.dart';

/// Localized name of a task category.
String taskCategoryLabel(AppLocalizations l10n, TaskCategory category) {
  switch (category) {
    case TaskCategory.ibadah:
      return l10n.taskCategoryIbadah;
    case TaskCategory.work:
      return l10n.taskCategoryWork;
    case TaskCategory.study:
      return l10n.taskCategoryStudy;
    case TaskCategory.family:
      return l10n.taskCategoryFamily;
    case TaskCategory.health:
      return l10n.taskCategoryHealth;
    case TaskCategory.rest:
      return l10n.taskCategoryRest;
  }
}

/// Formats [minutes] from midnight as a 24h clock string.
///
/// The app ships no AM/PM markers, so the 24h form is used in every locale
/// (see [format24h]) and the digits follow the user's numeral preference.
/// [context] stays part of the signature so the helper can be switched to a
/// localized 12h form later without touching its callers.
String clockText(BuildContext context, int minutes, bool useEastern) {
  final formatted = format24h(minutes);
  return useEastern ? toEastern(formatted) : formatted;
}

/// Clamps a `[start, end)` pair so the end always stays after the start and
/// the block keeps a minimum length of 15 minutes.
///
/// Valid pairs are kept untouched (so a hand-picked time is never rounded);
/// broken pairs are repaired with [normaliseRange].
(int, int) clampTaskRange(int start, int end) {
  final safeStart = start.clamp(0, minutesPerDay - 15);
  final lower = safeStart + 15 <= minutesPerDay ? safeStart + 15 : minutesPerDay;
  if (end >= lower && end <= minutesPerDay) return (safeStart, end);
  final (_, normalised) = normaliseRange(safeStart, end);
  final repaired = normalised < lower ? lower : normalised;
  return (safeStart, repaired > minutesPerDay ? minutesPerDay : repaired);
}

/// Builds an editable draft out of a stored task (used by the drag-resize).
TaskDraft taskDraftFromTask(
  Task task, {
  int? startMinutes,
  int? endMinutes,
}) {
  return TaskDraft(
    title: task.title,
    category: task.category,
    iconKey: task.iconKey,
    colorValue: task.colorValue,
    startMinutes: startMinutes ?? task.startMinutes,
    endMinutes: endMinutes ?? task.endMinutes,
    repeat: task.repeat,
    weekdaysMask: task.weekdaysMask,
    anchorDate: DateUtilsExt.parseYmd(task.anchorDate),
    reminderMinutes: task.reminderMinutes,
    note: task.note,
  );
}

/// One task block of the daily timeline.
///
/// The block shows the category accent, the task icon, the title, the time
/// range and the done toggle. The bottom edge can be dragged to resize the
/// task (only the end time moves, snapped to 15 minutes); the change is
/// written to the database once the finger is lifted.
class TimetableTaskTile extends ConsumerStatefulWidget {
  final Task task;
  final bool done;
  final DateTime day;
  final bool useEastern;
  final VoidCallback? onOpen;

  const TimetableTaskTile({
    super.key,
    required this.task,
    required this.done,
    required this.day,
    required this.useEastern,
    this.onOpen,
  });

  @override
  ConsumerState<TimetableTaskTile> createState() => _TimetableTaskTileState();
}

class _TimetableTaskTileState extends ConsumerState<TimetableTaskTile> {
  /// Raw (unsnapped) end time while the block is being resized.
  double? _dragEnd;

  int get _endMinutes {
    final raw = _dragEnd;
    if (raw == null) return widget.task.endMinutes;
    return snapMinutes(raw.round());
  }

  bool get _isNow {
    final now = DateTime.now();
    if (DateUtilsExt.ymd(now) != DateUtilsExt.ymd(widget.day)) return false;
    final minutes = now.hour * 60 + now.minute;
    return minutes >= widget.task.startMinutes && minutes < _endMinutes;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final base = _dragEnd ?? widget.task.endMinutes.toDouble();
    setState(() => _dragEnd = base + details.delta.dy / 2);
  }

  void _onDragEnd(DragEndDetails details) {
    final raw = _dragEnd;
    setState(() => _dragEnd = null);
    if (raw == null) return;
    final snapped = snapMinutes(raw.round());
    final (start, end) = clampTaskRange(widget.task.startMinutes, snapped);
    if (start == widget.task.startMinutes && end == widget.task.endMinutes) {
      return;
    }
    ref
        .read(timetableActionsProvider)
        .updateTask(
          widget.task.id,
          taskDraftFromTask(widget.task, startMinutes: start, endMinutes: end),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final accent = Color(widget.task.colorValue);
    final start = widget.task.startMinutes;
    final end = _endMinutes;
    final duration = end - start < 15 ? 15 : end - start;
    final height = (duration * 0.7).clamp(84.0, 240.0);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onOpen,
      child: Container(
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accent.withValues(alpha: 0.35)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Accent bar on the leading edge (right side in RTL).
            Container(width: 6, color: accent),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: height),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 8, 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            taskIcon(widget.task.iconKey),
                            size: 18,
                            color: accent,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.task.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                decoration: widget.done
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                          if (_isNow) ...[
                            const SizedBox(width: 6),
                            _NowChip(color: accent),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${clockText(context, start, widget.useEastern)}'
                        ' – '
                        '${clockText(context, end, widget.useEastern)}',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _CategoryChip(
                            color: accent,
                            label: taskCategoryLabel(
                              l10n,
                              widget.task.category,
                            ),
                          ),
                          if (widget.task.note != null &&
                              widget.task.note!.trim().isNotEmpty)
                            Icon(
                              Icons.notes,
                              size: 14,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                        ],
                      ),
                      _ResizeHandle(
                        onDragUpdate: _onDragUpdate,
                        onDragEnd: _onDragEnd,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 4, end: 8),
              child: Align(
                alignment: AlignmentDirectional.center,
                child: Tooltip(
                  message: widget.done ? l10n.done : l10n.notDone,
                  child: Checkbox(
                    value: widget.done,
                    onChanged: (value) => ref
                        .read(timetableActionsProvider)
                        .setDone(
                          taskId: widget.task.id,
                          day: widget.day,
                          done: value ?? false,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom edge of a task block: dragging it changes the end time.
class _ResizeHandle extends StatelessWidget {
  final GestureDragUpdateCallback onDragUpdate;
  final GestureDragEndCallback onDragEnd;

  const _ResizeHandle({required this.onDragUpdate, required this.onDragEnd});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: onDragUpdate,
      onVerticalDragEnd: onDragEnd,
      child: SizedBox(
        height: 22,
        width: double.infinity,
        child: Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: Icon(
            Icons.drag_handle,
            size: 16,
            color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}

/// Small "now" marker shown on the block that is currently running.
class _NowChip extends StatelessWidget {
  final Color color;
  const _NowChip({required this.color});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        l10n.timetableNow,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Category chip inside a task block.
class _CategoryChip extends StatelessWidget {
  final Color color;
  final String label;
  const _CategoryChip({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}
