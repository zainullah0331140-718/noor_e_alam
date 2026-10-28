import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../services/notification_scheduler.dart';
import '../services/notification_service.dart';
import '../utils/date_utils_ext.dart';
import 'app_providers.dart';
import 'ramadan_providers.dart';
import 'settings_providers.dart';

/// The scheduler that owns the platform reminder schedule.
final notificationSchedulerProvider = Provider<NotificationScheduler>((ref) {
  return NotificationScheduler(NotificationService.instance);
});

/// Keeps the platform notification schedule in sync with the user's
/// preferences, location and language.
///
/// Runs once at startup and again whenever any of those change, so toggling a
/// switch in Settings immediately (re)schedules the reminders.
class NotificationScheduleNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    final prefs = ref.watch(notificationPrefsProvider);
    final location = ref.watch(locationProvider);
    final locale = ref.watch(localeProvider);
    final today = DateUtilsExt.dateOnly(DateTime.now());
    final prayerTimes = ref.watch(prayerTimesProvider(today)).times;
    final scheduler = ref.read(notificationSchedulerProvider);
    // Hijri month 9 is Ramadan; the Sehri/Iftar reminders only apply then.
    final inRamadan = hijriOf(today).month == 9;

    final l10n = await AppLocalizations.delegate.load(
      _resolveLocale(locale),
    );

    await scheduler.sync(
      prayerEnabled: prefs.prayer,
      rozaEnabled: prefs.roza,
      prayerTimes: prayerTimes,
      inRamadan: inRamadan,
      timeZoneName: location.tzName,
      l10n: l10n,
    );
  }

  /// Maps the app locale onto a supported one, falling back to English.
  static Locale _resolveLocale(Locale? locale) {
    final supported = AppLocalizations.supportedLocales;
    final wanted = locale ?? WidgetsBinding.instance.platformDispatcher.locale;
    return supported.firstWhere(
      (l) => l.languageCode == wanted.languageCode,
      orElse: () => supported.first,
    );
  }
}

final notificationScheduleProvider =
    AsyncNotifierProvider<NotificationScheduleNotifier, void>(
      NotificationScheduleNotifier.new,
    );
