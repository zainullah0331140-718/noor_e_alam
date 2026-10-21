// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qaza_dao.dart';

// ignore_for_file: type=lint
mixin _$QazaDaoMixin on DatabaseAccessor<AppDatabase> {
  $QazaRecordsTable get qazaRecords => attachedDatabase.qazaRecords;
  QazaDaoManager get managers => QazaDaoManager(this);
}

class QazaDaoManager {
  final _$QazaDaoMixin _db;
  QazaDaoManager(this._db);
  $$QazaRecordsTableTableManager get qazaRecords =>
      $$QazaRecordsTableTableManager(_db.attachedDatabase, _db.qazaRecords);
}
