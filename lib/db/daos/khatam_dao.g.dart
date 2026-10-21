// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'khatam_dao.dart';

// ignore_for_file: type=lint
mixin _$KhatamDaoMixin on DatabaseAccessor<AppDatabase> {
  $KhatamsTable get khatams => attachedDatabase.khatams;
  $KhatamParasTable get khatamParas => attachedDatabase.khatamParas;
  KhatamDaoManager get managers => KhatamDaoManager(this);
}

class KhatamDaoManager {
  final _$KhatamDaoMixin _db;
  KhatamDaoManager(this._db);
  $$KhatamsTableTableManager get khatams =>
      $$KhatamsTableTableManager(_db.attachedDatabase, _db.khatams);
  $$KhatamParasTableTableManager get khatamParas =>
      $$KhatamParasTableTableManager(_db.attachedDatabase, _db.khatamParas);
}
