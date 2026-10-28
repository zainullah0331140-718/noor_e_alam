import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_common_ffi.dart';

import 'daos/azkar_dao.dart';
import 'daos/gheebat_dao.dart';
import 'daos/khatam_dao.dart';
import 'daos/muraqaba_dao.dart';
import 'daos/nafl_dao.dart';
import 'daos/namaz_dao.dart';
import 'daos/qaza_dao.dart';
import 'daos/ramadan_dao.dart';
import 'daos/tilawat_dao.dart';
import 'daos/timetable_dao.dart';
import 'enums.dart';
import 'tables.dart';

part 'app_database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'ibadah_tracker.sqlite'));
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
    }
    return NativeDatabase.createInBackground(file);
  });
}

@DriftDatabase(
  tables: [
    NamazEntries,
    NaflEntries,
    QazaRecords,
    TilawatEntries,
    TilawatPositions,
    CustomDhikrs,
    AzkarEntries,
    Khatams,
    KhatamParas,
    GheebatEntries,
    MuraqabaSessions,
    Tasks,
    TaskCompletions,
    RamadanSeasons,
    RamadanDays,
  ],
  daos: [
    NamazDao,
    NaflDao,
    QazaDao,
    TilawatDao,
    AzkarDao,
    KhatamDao,
    GheebatDao,
    MuraqabaDao,
    TimetableDao,
    RamadanDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// File-backed database (production). Seeding is triggered from main().
  AppDatabase() : super(_openConnection());

  /// In-memory database for tests.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    // Fresh install: create every table.
    onCreate: (m) async {
      await m.createAll();
    },
    // v1 shipped without data tables; each later phase adds its own tables
    // on top of existing user data (never recreated).
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createAll();
        return;
      }
      if (from < 3) {
        // Phase 3: Tilawat / Azkar / Khatam.
        await m.createTable(tilawatEntries);
        await m.createTable(tilawatPositions);
        await m.createTable(customDhikrs);
        await m.createTable(azkarEntries);
        await m.createTable(khatams);
        await m.createTable(khatamParas);
      }
      if (from < 4) {
        // Phase 4: Gheebat / Muraqaba / Timetable.
        await m.createTable(gheebatEntries);
        await m.createTable(muraqabaSessions);
        await m.createTable(tasks);
        await m.createTable(taskCompletions);
      }
      if (from < 5) {
        // Phase 5: Ramadan Hub.
        await m.createTable(ramadanSeasons);
        await m.createTable(ramadanDays);
      }
    },
  );
}
