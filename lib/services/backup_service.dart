import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';

import '../db/app_database.dart';

/// Result of a backup or restore operation.
class BackupResult {
  final bool success;
  final String? path;
  final String? error;
  final int rowCount;

  const BackupResult({
    required this.success,
    this.path,
    this.error,
    this.rowCount = 0,
  });
}

/// JSON backup / restore for the whole database.
///
/// The export is a single JSON document `{ version, exportedAt, tables: {
/// tableName: [rowJson, ...] } }`. Restore wipes every table then re-inserts
/// rows in dependency order inside one transaction, so a partial failure
/// leaves the database untouched.
class BackupService {
  final AppDatabase _db;
  BackupService(this._db);

  static const int _formatVersion = 1;
  static const String _fileName = 'ibadah_backup.json';

  /// Serialises every table to JSON and returns the document text.
  Future<String> exportJson() async {
    final tables = <String, List<Map<String, dynamic>>>{};

    tables['namazEntries'] =
        (await _db.select(_db.namazEntries).get()).map((r) => r.toJson()).toList();
    tables['naflEntries'] =
        (await _db.select(_db.naflEntries).get()).map((r) => r.toJson()).toList();
    tables['qazaRecords'] =
        (await _db.select(_db.qazaRecords).get()).map((r) => r.toJson()).toList();
    tables['tilawatEntries'] =
        (await _db.select(_db.tilawatEntries).get()).map((r) => r.toJson()).toList();
    tables['tilawatPositions'] =
        (await _db.select(_db.tilawatPositions).get()).map((r) => r.toJson()).toList();
    tables['customDhikrs'] =
        (await _db.select(_db.customDhikrs).get()).map((r) => r.toJson()).toList();
    tables['azkarEntries'] =
        (await _db.select(_db.azkarEntries).get()).map((r) => r.toJson()).toList();
    tables['khatams'] =
        (await _db.select(_db.khatams).get()).map((r) => r.toJson()).toList();
    tables['khatamParas'] =
        (await _db.select(_db.khatamParas).get()).map((r) => r.toJson()).toList();
    tables['gheebatEntries'] =
        (await _db.select(_db.gheebatEntries).get()).map((r) => r.toJson()).toList();
    tables['muraqabaSessions'] =
        (await _db.select(_db.muraqabaSessions).get()).map((r) => r.toJson()).toList();
    tables['tasks'] =
        (await _db.select(_db.tasks).get()).map((r) => r.toJson()).toList();
    tables['taskCompletions'] =
        (await _db.select(_db.taskCompletions).get()).map((r) => r.toJson()).toList();
    tables['ramadanSeasons'] =
        (await _db.select(_db.ramadanSeasons).get()).map((r) => r.toJson()).toList();
    tables['ramadanDays'] =
        (await _db.select(_db.ramadanDays).get()).map((r) => r.toJson()).toList();

    final doc = {
      'version': _formatVersion,
      'app': 'noor_e_amal',
      'exportedAt': DateTime.now().toIso8601String(),
      'tables': tables,
    };
    return const JsonEncoder.withIndent('  ').convert(doc);
  }

  /// Writes the backup JSON into the app documents directory.
  Future<BackupResult> exportToFile() async {
    try {
      final json = await exportJson();
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}${Platform.pathSeparator}$_fileName');
      await file.writeAsString(json);
      final rows = (jsonDecode(json)['tables'] as Map)
          .values
          .fold<int>(0, (sum, list) => sum + (list as List).length);
      return BackupResult(success: true, path: file.path, rowCount: rows);
    } catch (e) {
      return BackupResult(success: false, error: e.toString());
    }
  }

  /// Restores a backup from a JSON [String], replacing all current data.
  Future<BackupResult> restoreFromJson(String jsonText) async {
    try {
      final decoded = jsonDecode(jsonText) as Map<String, dynamic>;
      final tables = decoded['tables'] as Map<String, dynamic>?;
      if (tables == null) {
        return const BackupResult(
          success: false,
          error: 'Invalid backup: missing "tables"',
        );
      }

      var total = 0;
      await _db.transaction(() async {
        // Wipe children before parents to respect FKs.
        await _db.delete(_db.taskCompletions).go();
        await _db.delete(_db.khatamParas).go();
        await _db.delete(_db.ramadanDays).go();
        await _db.delete(_db.tasks).go();
        await _db.delete(_db.khatams).go();
        await _db.delete(_db.ramadanSeasons).go();
        await _db.delete(_db.namazEntries).go();
        await _db.delete(_db.naflEntries).go();
        await _db.delete(_db.qazaRecords).go();
        await _db.delete(_db.tilawatEntries).go();
        await _db.delete(_db.tilawatPositions).go();
        await _db.delete(_db.customDhikrs).go();
        await _db.delete(_db.azkarEntries).go();
        await _db.delete(_db.gheebatEntries).go();
        await _db.delete(_db.muraqabaSessions).go();

        // Re-insert in dependency order.
        for (final row in _rows(tables, 'namazEntries')) {
          await _db.into(_db.namazEntries).insert(NamazEntry.fromJson(row));
          total++;
        }
        for (final row in _rows(tables, 'naflEntries')) {
          await _db.into(_db.naflEntries).insert(NaflEntry.fromJson(row));
          total++;
        }
        for (final row in _rows(tables, 'qazaRecords')) {
          await _db.into(_db.qazaRecords).insert(QazaRecord.fromJson(row));
          total++;
        }
        for (final row in _rows(tables, 'tilawatEntries')) {
          await _db.into(_db.tilawatEntries).insert(TilawatEntry.fromJson(row));
          total++;
        }
        for (final row in _rows(tables, 'tilawatPositions')) {
          await _db
              .into(_db.tilawatPositions)
              .insert(TilawatPosition.fromJson(row));
          total++;
        }
        for (final row in _rows(tables, 'customDhikrs')) {
          await _db.into(_db.customDhikrs).insert(CustomDhikr.fromJson(row));
          total++;
        }
        for (final row in _rows(tables, 'azkarEntries')) {
          await _db.into(_db.azkarEntries).insert(AzkarEntry.fromJson(row));
          total++;
        }
        for (final row in _rows(tables, 'khatams')) {
          await _db.into(_db.khatams).insert(Khatam.fromJson(row));
          total++;
        }
        for (final row in _rows(tables, 'gheebatEntries')) {
          await _db.into(_db.gheebatEntries).insert(GheebatEntry.fromJson(row));
          total++;
        }
        for (final row in _rows(tables, 'muraqabaSessions')) {
          await _db
              .into(_db.muraqabaSessions)
              .insert(MuraqabaSession.fromJson(row));
          total++;
        }
        for (final row in _rows(tables, 'tasks')) {
          await _db.into(_db.tasks).insert(Task.fromJson(row));
          total++;
        }
        for (final row in _rows(tables, 'khatamParas')) {
          await _db.into(_db.khatamParas).insert(KhatamPara.fromJson(row));
          total++;
        }
        for (final row in _rows(tables, 'taskCompletions')) {
          await _db
              .into(_db.taskCompletions)
              .insert(TaskCompletion.fromJson(row));
          total++;
        }
        for (final row in _rows(tables, 'ramadanSeasons')) {
          await _db.into(_db.ramadanSeasons).insert(RamadanSeason.fromJson(row));
          total++;
        }
        for (final row in _rows(tables, 'ramadanDays')) {
          await _db.into(_db.ramadanDays).insert(RamadanDay.fromJson(row));
          total++;
        }
      });

      return BackupResult(success: true, rowCount: total);
    } catch (e) {
      return BackupResult(success: false, error: e.toString());
    }
  }

  /// Restores from a `Uint8List` (file picker result).
  Future<BackupResult> restoreFromBytes(Uint8List bytes) {
    return restoreFromJson(utf8.decode(bytes));
  }

  /// Reads the on-disk backup file (if any) and restores it.
  Future<BackupResult> restoreFromFile() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}${Platform.pathSeparator}$_fileName');
      if (!await file.exists()) {
        return const BackupResult(
          success: false,
          error: 'No backup file found',
        );
      }
      return restoreFromJson(await file.readAsString());
    } catch (e) {
      return BackupResult(success: false, error: e.toString());
    }
  }

  List<Map<String, dynamic>> _rows(
    Map<String, dynamic> tables,
    String name,
  ) {
    final list = tables[name] as List?;
    if (list == null) return const [];
    return list
        .whereType<Map>()
        .map((m) => m.cast<String, dynamic>())
        .toList();
  }
}
