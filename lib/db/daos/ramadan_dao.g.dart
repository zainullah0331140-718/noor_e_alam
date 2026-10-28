// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ramadan_dao.dart';

// ignore_for_file: type=lint
mixin _$RamadanDaoMixin on DatabaseAccessor<AppDatabase> {
  $RamadanSeasonsTable get ramadanSeasons => attachedDatabase.ramadanSeasons;
  $RamadanDaysTable get ramadanDays => attachedDatabase.ramadanDays;
  RamadanDaoManager get managers => RamadanDaoManager(this);
}

class RamadanDaoManager {
  final _$RamadanDaoMixin _db;
  RamadanDaoManager(this._db);
  $$RamadanSeasonsTableTableManager get ramadanSeasons =>
      $$RamadanSeasonsTableTableManager(
        _db.attachedDatabase,
        _db.ramadanSeasons,
      );
  $$RamadanDaysTableTableManager get ramadanDays =>
      $$RamadanDaysTableTableManager(_db.attachedDatabase, _db.ramadanDays);
}
