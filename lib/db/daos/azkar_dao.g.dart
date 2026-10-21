// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'azkar_dao.dart';

// ignore_for_file: type=lint
mixin _$AzkarDaoMixin on DatabaseAccessor<AppDatabase> {
  $AzkarEntriesTable get azkarEntries => attachedDatabase.azkarEntries;
  $CustomDhikrsTable get customDhikrs => attachedDatabase.customDhikrs;
  AzkarDaoManager get managers => AzkarDaoManager(this);
}

class AzkarDaoManager {
  final _$AzkarDaoMixin _db;
  AzkarDaoManager(this._db);
  $$AzkarEntriesTableTableManager get azkarEntries =>
      $$AzkarEntriesTableTableManager(_db.attachedDatabase, _db.azkarEntries);
  $$CustomDhikrsTableTableManager get customDhikrs =>
      $$CustomDhikrsTableTableManager(_db.attachedDatabase, _db.customDhikrs);
}
