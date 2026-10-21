// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'namaz_dao.dart';

// ignore_for_file: type=lint
mixin _$NamazDaoMixin on DatabaseAccessor<AppDatabase> {
  $NamazEntriesTable get namazEntries => attachedDatabase.namazEntries;
  $QazaRecordsTable get qazaRecords => attachedDatabase.qazaRecords;
  NamazDaoManager get managers => NamazDaoManager(this);
}

class NamazDaoManager {
  final _$NamazDaoMixin _db;
  NamazDaoManager(this._db);
  $$NamazEntriesTableTableManager get namazEntries =>
      $$NamazEntriesTableTableManager(_db.attachedDatabase, _db.namazEntries);
  $$QazaRecordsTableTableManager get qazaRecords =>
      $$QazaRecordsTableTableManager(_db.attachedDatabase, _db.qazaRecords);
}
