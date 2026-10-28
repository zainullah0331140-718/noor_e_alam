import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Wraps [FlutterLocalNotificationsPlugin] with the app's prayer + Ramadan
/// reminders. All scheduling is best-effort: unsupported platforms (or a
/// denied permission) simply no-op instead of throwing into the UI.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// Whether the timezone database has been loaded. [tzdata.initializeTimeZones]
  /// resets [tz.local] back to UTC, so it must not be called again after the
  /// local location has been set.
  bool _tzReady = false;

  /// IANA zone the reminders are scheduled in. Defaults to Pakistan time.
  String _timeZoneName = 'Asia/Karachi';

  /// Notification ids owned by the scheduler. Each block is a contiguous range
  /// so a re-sync can cancel exactly what it owns without touching the
  /// one-shot test notification (id 0).
  static const int prayerReminderIdBase = 100;
  static const int rozaReminderIdBase = 200;

  /// Number of daily prayer reminders that can be scheduled (Fajr..Isha).
  static const int prayerReminderCount = 5;

  /// Number of Ramadan reminders (Sehri + Iftar).
  static const int rozaReminderCount = 2;

  static const _channelId = 'ibadah_reminders';
  static const _channelName = 'Ibadah Reminders';
  static const _channelDesc = 'Prayer times and Ramadan reminders';

  /// Selects the IANA zone the reminders are scheduled in, e.g. `Asia/Karachi`.
  /// Safe to call before [init]; the timezone database is loaded on demand.
  void useTimeZone(String name) {
    if (!_tzReady) {
      tzdata.initializeTimeZones();
      _tzReady = true;
    }
    try {
      tz.setLocalLocation(tz.getLocation(name));
      _timeZoneName = name;
    } catch (error) {
      // An unknown IANA name must not crash the app; fall back to UTC.
      _timeZoneName = 'UTC';
      tz.setLocalLocation(tz.getLocation('UTC'));
      developer.log(
        'Unknown time zone "$name", falling back to UTC',
        name: 'noor_e_amal.notifications',
        error: error,
      );
    }
  }

  /// Initializes timezone data and the plugin. Safe to call repeatedly.
  Future<bool> init() async {
    if (!_tzReady) {
      tzdata.initializeTimeZones();
      _tzReady = true;
    }
    // Must come after initializeTimeZones(), which resets tz.local to UTC.
    tz.setLocalLocation(tz.getLocation(_timeZoneName));

    if (_initialized) return true;

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    final settings = InitializationSettings(
      android: android,
      iOS: darwin,
      macOS: darwin,
      linux: const LinuxInitializationSettings(
        defaultActionName: 'Open',
      ),
      // Windows refuses to initialize unless all three of these are provided.
      windows: const WindowsInitializationSettings(
        appName: 'Noor-e-Amal',
        appUserModelId: 'com.noor.noor_e_amal',
        guid: '190e4f85-aa1c-4c97-8546-73897cc6f5c5',
      ),
    );

    final ok = await _plugin.initialize(settings: settings);
    _initialized = ok ?? false;
    return _initialized;
  }

  /// Requests the platform notification permission (Android 13+/iOS).
  Future<bool> requestPermission() async {
    if (kIsWeb) return false;
    if (Platform.isAndroid) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final granted = await android?.requestNotificationsPermission();
      return granted ?? false;
    }
    if (Platform.isIOS || Platform.isMacOS) {
      final ios = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      final granted = await ios?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }
    return true;
  }

  /// Immediate test notification (used by the Settings tile).
  Future<void> showTest() async {
    await init();
    await _plugin.show(
      id: 0,
      title: 'Ibadah Tracker',
      body: 'Notifications are working — MashaAllah.',
      notificationDetails: _details(),
    );
  }

  /// Schedules a daily-repeating reminder at [time] with [id].
  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    await init();
    final now = tz.TZDateTime.now(tz.local);
    var next = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (next.isBefore(now)) next = next.add(const Duration(days: 1));

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: next,
      notificationDetails: _details(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Cancels one scheduled notification.
  Future<void> cancel(int id) => _plugin.cancel(id: id);

  /// Cancels every scheduled notification.
  Future<void> cancelAll() => _plugin.cancelAll();

  /// Cancels every notification the scheduler owns (the prayer block and the
  /// roza block), leaving other notifications (e.g. the one-shot test
  /// notification) untouched.
  Future<void> cancelScheduled() async {
    for (var i = 0; i < prayerReminderCount; i++) {
      await _plugin.cancel(id: prayerReminderIdBase + i);
    }
    for (var i = 0; i < rozaReminderCount; i++) {
      await _plugin.cancel(id: rozaReminderIdBase + i);
    }
  }

  NotificationDetails _details() {
    const android = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.high,
      priority: Priority.high,
    );
    const darwin = DarwinNotificationDetails();
    const windows = WindowsNotificationDetails();
    const linux = LinuxNotificationDetails();
    return const NotificationDetails(
      android: android,
      iOS: darwin,
      macOS: darwin,
      windows: windows,
      linux: linux,
    );
  }
}
