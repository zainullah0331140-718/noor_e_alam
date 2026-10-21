import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/app_database.dart';
import '../db/daos/timetable_dao.dart';
import '../db/enums.dart';
import '../utils/date_utils_ext.dart';
import '../utils/timetable_utils.dart';
import 'app_providers.dart';

// â”€â”€ DAO â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

final timetableDaoProvider = Provider<TimetableDao>((ref) {
  return ref.watch(dbProvider).timetableDao;
});

// â”€â”€ Tasks â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

/// Live task definitions ordered by start time.
final timetableTasksProvider = StreamProvider<List<Task>>((ref) {
  return ref.watch(timetableDaoProvider).watchTasks();
});

/// Done task ids for one day (ymd).
final timetableDayProvider = StreamProvider.family<Set<int>, String>((
  ref,
  date,
) {
  return ref
      .watch(timetableDaoProvider)
      .watchDay(date)
      .map((rows) => rows.where((r) => r.done).map((r) => r.taskId).toSet());
});

/// Completions inside [range] (statistics source).
final timetableCompletionsProvider =
    FutureProvider.family<List<TaskCompletion>, DateRange>((ref, range) {
      return ref.watch(timetableDaoProvider).completionsInRange(range);
    });

// â”€â”€ Actions â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

/// Input object used when creating or editing a task from the UI.
class TaskDraft {
  final String title;
  final TaskCategory category;
  final String iconKey;
  final int colorValue;
  final int startMinutes;
  final int endMinutes;
  final TaskRepeat repeat;
  final int weekdaysMask;
  final DateTime anchorDate;
  final int? reminderMinutes;
  final String? note;

  const TaskDraft({
    required this.title,
    required this.category,
    required this.iconKey,
    required this.colorValue,
    required this.startMinutes,
    required this.endMinutes,
    required this.repeat,
    required this.weekdaysMask,
    required this.anchorDate,
    this.reminderMinutes,
    this.note,
  });

  TasksCompanion toCompanion() {
    return TasksCompanion.insert(
      title: title,
      category: Value(category),
      iconKey: Value(iconKey),
      colorValue: Value(colorValue),
      startMinutes: Value(startMinutes),
      endMinutes: Value(endMinutes),
      repeat: Value(repeat),
      weekdaysMask: Value(weekdaysMask),
      anchorDate: DateUtilsExt.ymd(anchorDate),
      reminderMinutes: Value(reminderMinutes),
      note: Value(note),
    );
  }
}

class TimetableActions {
  final TimetableDao _dao;
  const TimetableActions(this._dao);

  Future<int> addTask(TaskDraft draft) => _dao.addTask(draft.toCompanion());

  Future<void> updateTask(int id, TaskDraft draft) async {
    final companion = draft.toCompanion().copyWith(
      updatedAt: Value(DateTime.now()),
    );
    await _dao.updateTask(id, companion);
  }

  Future<void> deleteTask(int id) => _dao.deleteTask(id);

  Future<void> setDone({
    required int taskId,
    required DateTime day,
    required bool done,
  }) {
    return _dao.setDone(
      taskId: taskId,
      date: DateUtilsExt.ymd(day),
      done: done,
    );
  }
}

final timetableActionsProvider = Provider<TimetableActions>((ref) {
  return TimetableActions(ref.watch(timetableDaoProvider));
});

// â”€â”€ Statistics â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

/// Completion summary for one day / range.
class TimetableStats {
  /// Scheduled occurrences per category.
  final Map<TaskCategory, int> scheduledByCategory;

  /// Completed occurrences per category.
  final Map<TaskCategory, int> doneByCategory;

  final int scheduled;
  final int done;
  final int minutesScheduled;
  final int minutesDone;

  const TimetableStats({
    required this.scheduledByCategory,
    required this.doneByCategory,
    required this.scheduled,
    required this.done,
    required this.minutesScheduled,
    required this.minutesDone,
  });

  double get completion => scheduled == 0 ? 0 : done / scheduled;
}

/// Aggregates occurrences and completions for [range].
final timetableStatsProvider =
    FutureProvider.family<TimetableStats, DateRange>((ref, range) async {
      final dao = ref.watch(timetableDaoProvider);
      final tasks = await dao.getTasks();
      final completions = await dao.completionsInRange(range);
      final doneIdsByDay = <String, Set<int>>{};
      for (final c in completions) {
        if (!c.done) continue;
        doneIdsByDay.putIfAbsent(c.date, () => <int>{}).add(c.taskId);
      }

      final scheduledByCategory = <TaskCategory, int>{};
      final doneByCategory = <TaskCategory, int>{};
      var scheduled = 0;
      var done = 0;
      var minutesScheduled = 0;
      var minutesDone = 0;

      final start = DateUtilsExt.parseYmd(range.startYmd);
      final end = DateUtilsExt.parseYmd(range.endYmd);
      for (
        var day = start;
        !day.isAfter(end);
        day = DateTime(day.year, day.month, day.day + 1)
      ) {
        final ymd = DateUtilsExt.ymd(day);
        final doneIds = doneIdsByDay[ymd] ?? const <int>{};
        for (final task in tasks) {
          final occurs = taskOccursOn(
            repeat: task.repeat,
            weekdaysMask: task.weekdaysMask,
            anchorDate: task.anchorDate,
            day: day,
          );
          if (!occurs) continue;
          scheduled++;
          scheduledByCategory[task.category] =
              (scheduledByCategory[task.category] ?? 0) + 1;
          minutesScheduled += task.endMinutes - task.startMinutes;
          if (doneIds.contains(task.id)) {
            done++;
            doneByCategory[task.category] =
                (doneByCategory[task.category] ?? 0) + 1;
            minutesDone += task.endMinutes - task.startMinutes;
          }
        }
      }

      return TimetableStats(
        scheduledByCategory: scheduledByCategory,
        doneByCategory: doneByCategory,
        scheduled: scheduled,
        done: done,
        minutesScheduled: minutesScheduled,
        minutesDone: minutesDone,
      );
    });

