// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gheebat_dao.dart';

// ignore_for_file: type=lint
mixin _$GheebatDaoMixin on DatabaseAccessor<AppDatabase> {
  $GheebatEntriesTable get gheebatEntries => attachedDatabase.gheebatEntries;
  GheebatDaoManager get managers => GheebatDaoManager(this);
}

class GheebatDaoManager {
  final _$GheebatDaoMixin _db;
  GheebatDaoManager(this._db);
  $$GheebatEntriesTableTableManager get gheebatEntries =>
      $$GheebatEntriesTableTableManager(
        _db.attachedDatabase,
        _db.gheebatEntries,
      );
}
