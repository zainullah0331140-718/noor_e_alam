import 'dart:developer' as developer;

import 'package:timezone/timezone.dart' as tz;

import '../db/enums.dart';
import '../l10n/app_localizations.dart';
import 'notification_service.dart';

/// A single daily reminder to be handed to the platform.
class ScheduledReminder {
  /// Notification id, unique within the scheduler's owned blocks.
  final int id;

  /// Notification title.
  final String title;

  /// Notification body.
  final String body;

  /// Local clock time of day the reminder fires.
  final int hour;
  final int minute;

  const ScheduledReminder({
    required this.id,
    required this.title,
    required this.body,
    required this.hour,
    required this.minute,
  });

  @override
  String toString() =>
      'ScheduledReminder(id: $id, "$title" @ ${hour.toString().padLeft(2, '0')}:'
      '${minute.toString().padLeft(2, '0')})';
}

/// Computes and applies the daily prayer / Ramadan reminders.
///
/// The planner is deliberately pure so the schedule can be unit-tested without
/// a platform channel: [plan] maps "which reminders are on" plus "the prayer
/// times" onto a list of [ScheduledReminder]s, and [sync] applies it.
class NotificationScheduler {
  NotificationScheduler(this._service);

  final NotificationService _service;

  /// Sehri is eaten shortly before the fast begins at Fajr, so the reminder
  /// leads the Fajr prayer time by this many minutes.
  static const int sehriLeadMinutes = 20;

  /// The five obligatory prayers, in the order their reminders are scheduled.
  static const List<NamazType> _remindedPrayers = [
    NamazType.fajr,
    NamazType.zuhr,
    NamazType.asr,
    NamazType.maghrib,
    NamazType.isha,
  ];

  /// Builds the reminder list without touching the platform.
  ///
  /// [prayerTimes] maps a [NamazType] to the absolute instant of that prayer.
  /// [inRamadan] gates the Sehri/Iftar reminders, which only make sense during
  /// Ramadan. [timeZoneName] is the IANA zone the reminders fire in; instants
  /// are converted into that zone so the clock time matches what the user sees
  /// in the app even when the device sits in a different zone.
  static List<ScheduledReminder> plan({
    required bool prayerEnabled,
    required bool rozaEnabled,
    required Map<NamazType, DateTime> prayerTimes,
    required bool inRamadan,
    required String timeZoneName,
    required AppLocalizations l10n,
  }) {
    final location = tz.getLocation(timeZoneName);
    final reminders = <ScheduledReminder>[];

    if (prayerEnabled) {
      var index = 0;
      for (final prayer in _remindedPrayers) {
        final instant = prayerTimes[prayer];
        if (instant == null) continue;
        final local = tz.TZDateTime.from(instant, location);
        reminders.add(
          ScheduledReminder(
            id: NotificationService.prayerReminderIdBase + index,
            title: l10n.notifPrayerTitle,
            body: l10n.notifPrayerBody(_prayerName(prayer, l10n)),
            hour: local.hour,
            minute: local.minute,
          ),
        );
        index++;
      }
    }

    if (rozaEnabled && inRamadan) {
      final fajr = prayerTimes[NamazType.fajr];
      if (fajr != null) {
        final local = tz.TZDateTime.from(fajr, location);
        // The meal must be finished before the fast starts, hence the lead.
        final sehri = local.subtract(
          const Duration(minutes: sehriLeadMinutes),
        );
        reminders.add(
          ScheduledReminder(
            id: NotificationService.rozaReminderIdBase,
            title: l10n.notifRozaTitle,
            body: l10n.notifRozaBody(l10n.ramadanSehriTime),
            hour: sehri.hour,
            minute: sehri.minute,
          ),
        );
      }

      final maghrib = prayerTimes[NamazType.maghrib];
      if (maghrib != null) {
        final local = tz.TZDateTime.from(maghrib, location);
        reminders.add(
          ScheduledReminder(
            id: NotificationService.rozaReminderIdBase + 1,
            title: l10n.notifRozaTitle,
            body: l10n.notifRozaBody(l10n.ramadanIftarTime),
            hour: local.hour,
            minute: local.minute,
          ),
        );
      }
    }

    return reminders;
  }

  /// Replaces the platform schedule with a freshly computed one.
  ///
  /// Everything the scheduler owns is cancelled first so a prayer time that
  /// drifted since the last run does not leave a stale duplicate behind.
  Future<void> sync({
    required bool prayerEnabled,
    required bool rozaEnabled,
    required Map<NamazType, DateTime> prayerTimes,
    required bool inRamadan,
    required String timeZoneName,
    required AppLocalizations l10n,
  }) async {
    _service.useTimeZone(timeZoneName);
    try {
      await _service.init();
    } catch (error) {
      _log('Could not initialize the notification plugin', error);
      return;
    }

    final reminders = plan(
      prayerEnabled: prayerEnabled,
      rozaEnabled: rozaEnabled,
      prayerTimes: prayerTimes,
      inRamadan: inRamadan,
      timeZoneName: timeZoneName,
      l10n: l10n,
    );

    try {
      await _service.cancelScheduled();
    } catch (error) {
      _log('Could not clear the previous reminders', error);
    }

    for (final reminder in reminders) {
      try {
        await _service.scheduleDaily(
          id: reminder.id,
          title: reminder.title,
          body: reminder.body,
          hour: reminder.hour,
          minute: reminder.minute,
        );
      } catch (error) {
        // Best-effort: a platform that cannot schedule (or a permission that
        // was revoked) must never take the app down with it.
        _log('Could not schedule reminder ${reminder.id}', error);
      }
    }
  }

  static void _log(String message, Object error) {
    developer.log(
      message,
      name: 'noor_e_amal.notifications',
      error: error,
    );
  }

  static String _prayerName(NamazType prayer, AppLocalizations l10n) {
    switch (prayer) {
      case NamazType.fajr:
        return l10n.prayerFajr;
      case NamazType.zuhr:
        return l10n.prayerZuhr;
      case NamazType.asr:
        return l10n.prayerAsr;
      case NamazType.maghrib:
        return l10n.prayerMaghrib;
      case NamazType.isha:
        return l10n.prayerIsha;
      case NamazType.witr:
        return l10n.prayerIsha;
    }
  }
}
