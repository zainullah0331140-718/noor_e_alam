// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'muraqaba_dao.dart';

// ignore_for_file: type=lint
mixin _$MuraqabaDaoMixin on DatabaseAccessor<AppDatabase> {
  $MuraqabaSessionsTable get muraqabaSessions =>
      attachedDatabase.muraqabaSessions;
  MuraqabaDaoManager get managers => MuraqabaDaoManager(this);
}

class MuraqabaDaoManager {
  final _$MuraqabaDaoMixin _db;
  MuraqabaDaoManager(this._db);
  $$MuraqabaSessionsTableTableManager get muraqabaSessions =>
      $$MuraqabaSessionsTableTableManager(
        _db.attachedDatabase,
        _db.muraqabaSessions,
      );
}
