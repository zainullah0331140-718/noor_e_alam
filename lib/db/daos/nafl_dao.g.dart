// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nafl_dao.dart';

// ignore_for_file: type=lint
mixin _$NaflDaoMixin on DatabaseAccessor<AppDatabase> {
  $NaflEntriesTable get naflEntries => attachedDatabase.naflEntries;
  NaflDaoManager get managers => NaflDaoManager(this);
}

class NaflDaoManager {
  final _$NaflDaoMixin _db;
  NaflDaoManager(this._db);
  $$NaflEntriesTableTableManager get naflEntries =>
      $$NaflEntriesTableTableManager(_db.attachedDatabase, _db.naflEntries);
}
