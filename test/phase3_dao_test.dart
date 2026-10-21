import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_e_amal/db/app_database.dart';
import 'package:noor_e_amal/db/enums.dart';
import 'package:noor_e_amal/utils/azkar_catalog.dart';
import 'package:noor_e_amal/utils/date_utils_ext.dart';
import 'package:noor_e_amal/utils/streak_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('Tilawat totals, goal days, streaks and position', () async {
    const day = '2026-03-10';
    await db.tilawatDao.addEntry(date: day, unit: TilawatUnit.pages, amount: 4);
    await db.tilawatDao.addEntry(date: day, unit: TilawatUnit.pages, amount: 6);
    await db.tilawatDao.addEntry(
      date: day,
      unit: TilawatUnit.minutes,
      amount: 30,
    );
    await db.tilawatDao.addEntry(
      date: '2026-03-09',
      unit: TilawatUnit.pages,
      amount: 2,
    );

    final range = DateRange(startYmd: '2026-03-01', endYmd: '2026-03-31');
    final totals = await db.tilawatDao.rangeTotals(range);
    expect(totals.pages, 12);
    expect(totals.minutes, 30);
    expect(totals.days, 2);
    expect(totals.entries, 4);
    expect(totals.averagePerDay(TilawatUnit.pages), 6);

    expect(
      await db.tilawatDao.daysMeetingGoal(
        range,
        unit: TilawatUnit.pages,
        goal: 8,
      ),
      1,
    );

    final months = await db.tilawatDao.pagesByMonth(2026);
    expect(months[2], 12);
    expect(months[0], 0);

    final streak = await db.tilawatDao.streaks(todayYmd: day);
    expect(streak.current, 2);
    expect(streak.best, 2);

    expect(await db.tilawatDao.getPosition(), isNull);
    await db.tilawatDao.savePosition(para: 5, surah: "Al-Ma'idah", page: 106);
    final pos = await db.tilawatDao.getPosition();
    expect(pos?.para, 5);
    expect(pos?.surah, "Al-Ma'idah");
    expect(pos?.page, 106);
  });

  test('Azkar counters, custom dhikr and daily completion', () async {
    const day = '2026-03-10';
    const range = DateRange(startYmd: day, endYmd: day);

    await db.azkarDao.increment(
      date: day,
      dhikrKey: 'tasbeehSubhan',
      target: 33,
    );
    await db.azkarDao.increment(
      date: day,
      dhikrKey: 'tasbeehSubhan',
      target: 33,
    );
    await db.azkarDao.increment(
      date: day,
      dhikrKey: 'tasbeehSubhan',
      target: 33,
    );
    await db.azkarDao.setCount(
      date: day,
      dhikrKey: 'morning',
      count: 1,
      target: 1,
    );

    final rows = await db.azkarDao.watchDay(day).first;
    final byKey = {for (final r in rows) r.dhikrKey: r.count};
    expect(byKey['tasbeehSubhan'], 3);
    expect(byKey['morning'], 1);

    expect((await db.azkarDao.totalsByDhikr(range))['tasbeehSubhan'], 3);
    expect((await db.azkarDao.totalsByDay(range))[day], 4);

    final done = await db.azkarDao.fullyDoneDays(range, [
      'morning',
      'tasbeehSubhan',
    ]);
    expect(done, isEmpty);

    await db.azkarDao.setCount(
      date: day,
      dhikrKey: 'tasbeehSubhan',
      count: 33,
      target: 33,
    );
    final doneNow = await db.azkarDao.fullyDoneDays(range, [
      'morning',
      'tasbeehSubhan',
    ]);
    expect(doneNow, {day});

    final streak = await db.azkarDao.streaks(
      todayYmd: day,
      keys: ['morning', 'tasbeehSubhan'],
    );
    expect(streak.current, 1);

    final id = await db.azkarDao.addCustom(name: 'Salawat', target: 10);
    final customs = await db.azkarDao.watchCustomDhikrs().first;
    expect(customs.length, 1);
    expect(customs.single.name, 'Salawat');
    expect(customDhikrKey(id), 'custom:$id');

    await db.azkarDao.setCount(
      date: day,
      dhikrKey: customDhikrKey(id),
      count: 10,
      target: 10,
    );
    await db.azkarDao.deactivateCustom(id);
    expect(await db.azkarDao.watchCustomDhikrs().first, isEmpty);
    expect((await db.azkarDao.totalsByDhikr(range))[customDhikrKey(id)], 10);

    await db.azkarDao.resetDay(day);
    expect((await db.azkarDao.totalsByDay(range))[day], 0);
  });

  test('Khatam lifecycle, para sync and counters', () async {
    expect(await db.khatamDao.watchActive().first, isNull);

    final id = await db.khatamDao.startKhatam(startDate: '2026-02-01');
    final active = await db.khatamDao.watchActive().first;
    expect(active?.id, id);
    expect(active?.endDate, isNull);

    await db.khatamDao.setParaDone(id, 1, done: true, date: '2026-02-02');
    await db.khatamDao.setParaDone(id, 2, done: true, date: '2026-02-02');
    expect(await db.khatamDao.completedParas(id), 2);

    await db.khatamDao.markParasThrough(id, 5, date: '2026-02-03');
    expect(await db.khatamDao.completedParas(id), 5);
    expect(await db.khatamDao.watchDoneParas(id).first, {1, 2, 3, 4, 5});

    await db.khatamDao.setParaDone(id, 3, done: false, date: '2026-02-03');
    expect(await db.khatamDao.completedParas(id), 4);

    expect(await db.khatamDao.countInYear(2026), 0);
    await db.khatamDao.completeKhatam(id, endDate: '2026-03-01');
    expect(await db.khatamDao.watchActive().first, isNull);
    expect(await db.khatamDao.countInYear(2026), 1);
    expect(await db.khatamDao.countAll(), 1);
    expect(await db.khatamDao.completedByYear(), {2026: 1});
  });

  test('Streak helper keeps a grace day for an unfinished today', () {
    final days = {'2026-03-07', '2026-03-08', '2026-03-09'};
    final result = computeStreak(completedDays: days, todayYmd: '2026-03-10');
    expect(result.current, 3);
    expect(result.best, 3);

    expect(
      computeStreak(completedDays: const {}, todayYmd: '2026-03-10').current,
      0,
    );
    expect(daysInRange('2026-03-01', '2026-03-10'), 10);
  });
}
