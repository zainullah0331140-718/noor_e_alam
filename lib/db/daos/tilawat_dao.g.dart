// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tilawat_dao.dart';

// ignore_for_file: type=lint
mixin _$TilawatDaoMixin on DatabaseAccessor<AppDatabase> {
  $TilawatEntriesTable get tilawatEntries => attachedDatabase.tilawatEntries;
  $TilawatPositionsTable get tilawatPositions =>
      attachedDatabase.tilawatPositions;
  TilawatDaoManager get managers => TilawatDaoManager(this);
}

class TilawatDaoManager {
  final _$TilawatDaoMixin _db;
  TilawatDaoManager(this._db);
  $$TilawatEntriesTableTableManager get tilawatEntries =>
      $$TilawatEntriesTableTableManager(
        _db.attachedDatabase,
        _db.tilawatEntries,
      );
  $$TilawatPositionsTableTableManager get tilawatPositions =>
      $$TilawatPositionsTableTableManager(
        _db.attachedDatabase,
        _db.tilawatPositions,
      );
}
