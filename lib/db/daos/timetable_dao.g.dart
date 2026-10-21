// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable_dao.dart';

// ignore_for_file: type=lint
mixin _$TimetableDaoMixin on DatabaseAccessor<AppDatabase> {
  $TasksTable get tasks => attachedDatabase.tasks;
  $TaskCompletionsTable get taskCompletions => attachedDatabase.taskCompletions;
  TimetableDaoManager get managers => TimetableDaoManager(this);
}

class TimetableDaoManager {
  final _$TimetableDaoMixin _db;
  TimetableDaoManager(this._db);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db.attachedDatabase, _db.tasks);
  $$TaskCompletionsTableTableManager get taskCompletions =>
      $$TaskCompletionsTableTableManager(
        _db.attachedDatabase,
        _db.taskCompletions,
      );
}
