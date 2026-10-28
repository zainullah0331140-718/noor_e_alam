import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;

import 'package:noor_e_amal/db/enums.dart';
import 'package:noor_e_amal/l10n/app_localizations.dart';
import 'package:noor_e_amal/services/notification_scheduler.dart';
import 'package:noor_e_amal/services/notification_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppLocalizations l10n;

  setUpAll(() async {
    tzdata.initializeTimeZones();
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  /// Prayer instants expressed in UTC; Asia/Karachi is UTC+5 year-round.
  final utcTimes = <NamazType, DateTime>{
    NamazType.fajr: DateTime.utc(2026, 3, 10, 0, 15), // 05:15 PKT
    NamazType.zuhr: DateTime.utc(2026, 3, 10, 6, 30), // 11:30 PKT
    NamazType.asr: DateTime.utc(2026, 3, 10, 9, 45), // 14:45 PKT
    NamazType.maghrib: DateTime.utc(2026, 3, 10, 12, 5), // 17:05 PKT
    NamazType.isha: DateTime.utc(2026, 3, 10, 13, 20), // 18:20 PKT
  };

  List<ScheduledReminder> plan({
    bool prayerEnabled = false,
    bool rozaEnabled = false,
    bool inRamadan = false,
    Map<NamazType, DateTime>? times,
    String timeZoneName = 'Asia/Karachi',
  }) {
    return NotificationScheduler.plan(
      prayerEnabled: prayerEnabled,
      rozaEnabled: rozaEnabled,
      prayerTimes: times ?? utcTimes,
      inRamadan: inRamadan,
      timeZoneName: timeZoneName,
      l10n: l10n,
    );
  }

  test('nothing is scheduled while both toggles are off', () {
    expect(plan(), isEmpty);
  });

  test('prayer reminders cover the five obligatory prayers', () {
    final reminders = plan(prayerEnabled: true);

    expect(reminders, hasLength(5));
    expect(
      reminders.map((r) => r.id),
      [
        NotificationService.prayerReminderIdBase,
        NotificationService.prayerReminderIdBase + 1,
        NotificationService.prayerReminderIdBase + 2,
        NotificationService.prayerReminderIdBase + 3,
        NotificationService.prayerReminderIdBase + 4,
      ],
    );
    expect(
      reminders.map((r) => r.body),
      [
        'It is time for Fajr.',
        'It is time for Zuhr.',
        'It is time for Asr.',
        'It is time for Maghrib.',
        'It is time for Isha.',
      ],
    );
    expect(reminders.every((r) => r.title == 'Prayer Time'), isTrue);
  });

  test('prayer reminders use the clock time of the scheduling zone', () {
    final reminders = plan(prayerEnabled: true);

    // Fajr at 00:15 UTC is 05:15 in Asia/Karachi.
    expect(reminders[0].hour, 5);
    expect(reminders[0].minute, 15);
    // Isha at 13:20 UTC is 18:20 in Asia/Karachi.
    expect(reminders[4].hour, 18);
    expect(reminders[4].minute, 20);
  });

  test('a different scheduling zone shifts the clock time', () {
    final reminders = plan(prayerEnabled: true, timeZoneName: 'UTC');

    // Fajr at 00:15 UTC stays at 00:15 when scheduling in UTC.
    expect(reminders[0].hour, 0);
    expect(reminders[0].minute, 15);
  });

  test('roza reminders only appear during Ramadan', () {
    expect(plan(rozaEnabled: true), isEmpty);
    expect(plan(rozaEnabled: true, inRamadan: false), isEmpty);

    final reminders = plan(rozaEnabled: true, inRamadan: true);
    expect(reminders, hasLength(2));
    expect(
      reminders.map((r) => r.id),
      [
        NotificationService.rozaReminderIdBase,
        NotificationService.rozaReminderIdBase + 1,
      ],
    );
    expect(reminders[0].body, 'It is time for Sehri.');
    expect(reminders[1].body, 'It is time for Iftar.');
  });

  test('Sehri leads Fajr by 20 minutes and Iftar matches Maghrib', () {
    final reminders = plan(rozaEnabled: true, inRamadan: true);

    // Fajr 05:15 PKT -> Sehri 04:55 PKT.
    expect(reminders[0].hour, 4);
    expect(reminders[0].minute, 55);
    // Maghrib 17:05 PKT -> Iftar 17:05 PKT.
    expect(reminders[1].hour, 17);
    expect(reminders[1].minute, 5);
  });

  test('prayer and roza reminders coexist without sharing ids', () {
    final reminders = plan(
      prayerEnabled: true,
      rozaEnabled: true,
      inRamadan: true,
    );

    expect(reminders, hasLength(7));
    expect(
      reminders.map((r) => r.id).toSet(),
      hasLength(reminders.length),
    );
  });

  test('a missing prayer time is skipped instead of throwing', () {
    final times = Map<NamazType, DateTime>.of(utcTimes)..remove(NamazType.asr);

    final reminders = plan(prayerEnabled: true, times: times);

    expect(reminders, hasLength(4));
    expect(
      reminders.map((r) => r.body),
      isNot(contains('It is time for Asr.')),
    );
  });

  test('the prayer reminder ids stay inside the block the service owns', () {
    final reminders = plan(
      prayerEnabled: true,
      rozaEnabled: true,
      inRamadan: true,
    );

    for (final reminder in reminders) {
      final inPrayerBlock =
          reminder.id >= NotificationService.prayerReminderIdBase &&
          reminder.id <
              NotificationService.prayerReminderIdBase +
                  NotificationService.prayerReminderCount;
      final inRozaBlock =
          reminder.id >= NotificationService.rozaReminderIdBase &&
          reminder.id <
              NotificationService.rozaReminderIdBase +
                  NotificationService.rozaReminderCount;
      expect(inPrayerBlock || inRozaBlock, isTrue,
          reason: 'id ${reminder.id} is outside the owned ranges');
    }
  });
}
