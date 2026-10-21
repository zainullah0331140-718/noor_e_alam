import 'package:drift/drift.dart';

import '../../utils/date_utils_ext.dart';
import '../app_database.dart';
import '../tables.dart';

part 'timetable_dao.g.dart';

/// Data access for the Daily Timetable module.
///
/// Task definitions are stored once; occurrences are derived in Dart from
/// the repeat rule, so completion rows stay small (`taskId` + `date`).
@DriftAccessor(tables: [Tasks, TaskCompletions])
class TimetableDao extends DatabaseAccessor<AppDatabase>
    with _$TimetableDaoMixin {
  TimetableDao(super.db);

  // ── Tasks ───────────────────────────────────────────────────────────────

  /// Live task definitions, ordered by start time.
  Stream<List<Task>> watchTasks() {
    return (select(tasks)
          ..where((t) => t.active.equals(true))
          ..orderBy([(t) => OrderingTerm(expression: t.startMinutes)]))
        .watch();
  }

  Future<List<Task>> getTasks() {
    return (select(tasks)
          ..where((t) => t.active.equals(true))
          ..orderBy([(t) => OrderingTerm(expression: t.startMinutes)]))
        .get();
  }

  Future<int> addTask(TasksCompanion task) => into(tasks).insert(task);

  Future<bool> updateTask(int id, TasksCompanion task) {
    return (update(tasks)..where((t) => t.id.equals(id)))
        .write(task)
        .then((rows) => rows > 0);
  }

  Future<int> deleteTask(int id) {
    return (delete(tasks)..where((t) => t.id.equals(id))).go();
  }

  // ── Completions ─────────────────────────────────────────────────────────

  /// Live done rows for one day.
  Stream<List<TaskCompletion>> watchDay(String date) {
    return (select(
      taskCompletions,
    )..where((t) => t.date.equals(date))).watch();
  }

  /// Done rows inside [range] (statistics source).
  Future<List<TaskCompletion>> completionsInRange(DateRange range) {
    return (select(taskCompletions)..where(
          (t) =>
              t.date.isBiggerOrEqualValue(range.startYmd) &
              t.date.isSmallerOrEqualValue(range.endYmd),
        ))
        .get();
  }

  /// Marks one task occurrence done / not done.
  Future<void> setDone({
    required int taskId,
    required String date,
    required bool done,
  }) async {
    if (!done) {
      await (delete(taskCompletions)..where(
            (t) => t.taskId.equals(taskId) & t.date.equals(date),
          ))
          .go();
      return;
    }
    await into(taskCompletions).insertOnConflictUpdate(
      TaskCompletionsCompanion.insert(
        taskId: taskId,
        date: date,
        done: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
