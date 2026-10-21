import 'dart:math';

import '../utils/azkar_catalog.dart';
import '../utils/date_utils_ext.dart';
import 'app_database.dart';
import 'enums.dart';

/// One-time sample-data seeder.
///
/// Populates the last 30 days with a realistic mix of Namaz/Nafl/Qaza
/// rows so charts, streaks and the dashboard have something to show on a
/// fresh install. Runs only when the Namaz table is completely empty;
/// real user data is never touched.
class SeedService {
  final AppDatabase _db;
  SeedService(this._db);

  Future<void> seedIfEmpty() async {
    final already = await _db.select(_db.namazEntries).get();
    if (already.isNotEmpty) return;

    final rng = Random(42); // fixed seed → reproducible demo data
    final today = DateUtilsExt.dateOnly(DateTime.now());

    for (var daysAgo = 29; daysAgo >= 0; daysAgo--) {
      final date = today.subtract(Duration(days: daysAgo));
      final ymd = DateUtilsExt.ymd(date);
      // Today is left partially unmarked so the "Remaining" counter and
      // live summary have something to track.
      final isToday = daysAgo == 0;

      await _seedNamazDay(ymd, rng, isToday: isToday);
      await _seedNaflDay(ymd, rng, isToday: isToday);
    }

    // A few legacy qaza rakats so the Qaza manager isn't empty on Day 1.
    await _db.qazaDao.addManual(
      prayer: NamazType.asr,
      rakats: 3,
      note: 'Seed: old qaza before install',
    );
    await _db.qazaDao.addManual(
      prayer: NamazType.isha,
      rakats: 2,
      note: 'Seed: old qaza before install',
    );

    // Phase 3 modules (Tilawat, Azkar, Khatam).
    await _seedTilawat(rng, today);
    await _seedAzkar(rng, today);
    await _seedKhatam(today);
  }

  Future<void> _seedNamazDay(String ymd, Random rng, {required bool isToday}) async {
    for (final prayer in NamazType.values) {
      // Leave Maghrib + Witr of today unmarked for the live demo.
      if (isToday &&
          (prayer == NamazType.maghrib || prayer == NamazType.witr)) {
        continue;
      }
      final roll = rng.nextDouble();
      final NamazStatus status;
      if (roll < 0.72) {
        status = NamazStatus.jamaat;
      } else if (roll < 0.90) {
        status = NamazStatus.alone;
      } else {
        status = NamazStatus.missed;
      }
      await _db.namazDao.upsertStatus(
        date: ymd,
        prayer: prayer,
        status: status,
        takbeerUla: status != NamazStatus.missed && rng.nextDouble() < 0.8,
        masbooq: status != NamazStatus.missed && rng.nextDouble() < 0.1,
        atMasjid: status == NamazStatus.jamaat && rng.nextDouble() < 0.85,
      );
    }
  }

  Future<void> _seedNaflDay(String ymd, Random rng, {required bool isToday}) async {
    final fixed = const {
      NaflType.tahajjud: 2,
      NaflType.ishraq: 2,
      NaflType.chasht: 4,
      NaflType.awwabin: 12,
      NaflType.tahiyyatulWudu: 2,
      NaflType.tahiyyatulMasjid: 2,
      NaflType.sunnahMuakkadah: 12,
      NaflType.ghairMuakkadah: 2,
      NaflType.tasbeeh: 4,
      NaflType.hajat: 2,
      NaflType.tawbah: 2,
    };
    for (final entry in fixed.entries) {
      // Skip a couple of types on today so the checklist isn't pre-filled.
      if (isToday && entry.key != NaflType.tahajjud) continue;
      final doneRoll = rng.nextDouble();
      // Tahajjud done less often; Ishraq/Duha more often.
      final doneThreshold = switch (entry.key) {
        NaflType.tahajjud => 0.35,
        NaflType.chasht => 0.7,
        NaflType.awwabin => 0.4,
        _ => 0.6,
      };
      await _db.naflDao.upsertFixed(
        date: ymd,
        type: entry.key,
        done: isToday ? entry.key == NaflType.tahajjud : doneRoll < doneThreshold,
        rakats: entry.value,
      );
    }
    // One custom nafl every other day.
    if (ymd.hashCode % 2 == 0) {
      await _db.naflDao.upsertCustom(
        date: ymd,
        name: 'Salat-e-KanZ',
        done: rng.nextDouble() < 0.5,
        rakats: 2,
        note: 'Seed data',
      );
    }
  }

  // ── Phase 3: Tilawat ─────────────────────────────────────────────────────

  Future<void> _seedTilawat(Random rng, DateTime today) async {
    for (var daysAgo = 29; daysAgo >= 0; daysAgo--) {
      final date = today.subtract(Duration(days: daysAgo));
      final ymd = DateUtilsExt.ymd(date);
      final isToday = daysAgo == 0;
      // Skip some days entirely so streaks/heatmaps look realistic.
      if (!isToday && rng.nextDouble() < 0.25) continue;

      // Most days: one or two page-based sessions.
      final sessions = isToday ? 1 : (rng.nextDouble() < 0.4 ? 2 : 1);
      for (var i = 0; i < sessions; i++) {
        await _db.tilawatDao.addEntry(
          date: ymd,
          unit: TilawatUnit.pages,
          amount: 3 + rng.nextInt(8),
          note: i == 0 ? 'After Fajr' : 'After Isha',
        );
      }
      // Every few days add a short minutes-based session.
      if (!isToday && rng.nextDouble() < 0.25) {
        await _db.tilawatDao.addEntry(
          date: ymd,
          unit: TilawatUnit.minutes,
          amount: 10 + rng.nextInt(20),
          note: 'Revision',
        );
      }
    }

    // Reading position for the "Continue" card.
    await _db.tilawatDao.savePosition(
      para: 5,
      surah: "Al-Ma'idah",
      page: 106,
    );
  }

  // ── Phase 3: Azkar ───────────────────────────────────────────────────────

  Future<void> _seedAzkar(Random rng, DateTime today) async {
    for (var daysAgo = 29; daysAgo >= 0; daysAgo--) {
      final date = today.subtract(Duration(days: daysAgo));
      final ymd = DateUtilsExt.ymd(date);
      final isToday = daysAgo == 0;

      for (final item in azkarCatalog) {
        // Today: morning + durood complete, tasbeeh partially counted.
        if (isToday) {
          switch (item.key) {
            case 'morning':
            case 'durood':
              await _db.azkarDao.setCount(
                date: ymd,
                dhikrKey: item.key,
                count: item.defaultTarget,
                target: item.defaultTarget,
              );
            case 'tasbeehSubhan':
              await _db.azkarDao.setCount(
                date: ymd,
                dhikrKey: item.key,
                count: 20,
                target: item.defaultTarget,
              );
            default:
              break;
          }
          continue;
        }

        final roll = rng.nextDouble();
        if (roll < 0.35) continue; // not done at all
        final count = roll < 0.75
            ? item.defaultTarget
            : (item.defaultTarget * 0.5).round();
        await _db.azkarDao.setCount(
          date: ymd,
          dhikrKey: item.key,
          count: count,
          target: item.defaultTarget,
        );
      }
    }
  }

  // ── Phase 3: Khatam ──────────────────────────────────────────────────────

  Future<void> _seedKhatam(DateTime today) async {
    // One completed khatam (last month) with all 30 paras ticked.
    final completedStart = today.subtract(const Duration(days: 45));
    final completedEnd = today.subtract(const Duration(days: 12));
    final completedId = await _db.khatamDao.startKhatam(
      startDate: DateUtilsExt.ymd(completedStart),
    );
    await _db.khatamDao.markParasThrough(
      completedId,
      30,
      date: DateUtilsExt.ymd(completedEnd),
    );
    await _db.khatamDao.completeKhatam(
      completedId,
      endDate: DateUtilsExt.ymd(completedEnd),
    );

    // One active khatam with the first four paras done.
    final activeId = await _db.khatamDao.startKhatam(
      startDate: DateUtilsExt.ymd(today.subtract(const Duration(days: 5))),
    );
    await _db.khatamDao.markParasThrough(
      activeId,
      4,
      date: DateUtilsExt.ymd(today),
    );
  }
}
