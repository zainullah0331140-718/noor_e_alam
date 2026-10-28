import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/enums.dart';
import '../db/seed_service.dart';
import '../services/backup_service.dart';
import '../utils/date_utils_ext.dart';
import 'app_providers.dart';

// ── Database seeding ──────────────────────────────────────────────────────

/// Runs the one-time sample-data seed. main() awaits this before showing
/// the app so charts have data on a fresh install.
final seedProvider = FutureProvider<void>((ref) async {
  final db = ref.watch(dbProvider);
  await SeedService(db).seedIfEmpty();
});

// ── Settings: nafl goal ───────────────────────────────────────────────────

class NaflGoalNotifier extends Notifier<int> {
  static const _key = 'nafl_daily_goal';
  @override
  int build() {
    final prefs = ref.watch(sharedPrefsProvider);
    return prefs.getInt(_key) ?? 24;
  }

  Future<void> set(int v) async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setInt(_key, v);
    state = v;
  }
}

final naflGoalProvider = NotifierProvider<NaflGoalNotifier, int>(
  NaflGoalNotifier.new,
);

// ── Settings: prayer-time location ────────────────────────────────────────

/// Immutable location used by the adhan prayer-time calculator.
class PrayerLocation {
  final String name;
  final double latitude;
  final double longitude;

  /// IANA zone the prayer times and the reminders are scheduled in.
  /// Pakistan observes PKT (UTC+5) year-round, so every city shares it.
  final String tzName;

  const PrayerLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.tzName = 'Asia/Karachi',
  });

  static const paksitanDefault = PrayerLocation(
    name: 'Islamabad',
    latitude: 33.6844,
    longitude: 73.0479,
  );

  static const cities = <PrayerLocation>[
    paksitanDefault,
    PrayerLocation(name: 'Karachi', latitude: 24.8607, longitude: 67.0011),
    PrayerLocation(name: 'Lahore', latitude: 31.5204, longitude: 74.3587),
    PrayerLocation(name: 'Peshawar', latitude: 34.0151, longitude: 71.5249),
    PrayerLocation(name: 'Quetta', latitude: 30.1798, longitude: 66.9750),
    PrayerLocation(name: 'Multan', latitude: 30.1575, longitude: 71.5249),
  ];
}

class LocationNotifier extends Notifier<PrayerLocation> {
  static const _key = 'prayer_location';
  @override
  PrayerLocation build() {
    final prefs = ref.watch(sharedPrefsProvider);
    final name = prefs.getString(_key);
    return PrayerLocation.cities.firstWhere(
      (c) => c.name == name,
      orElse: () => PrayerLocation.paksitanDefault,
    );
  }

  Future<void> set(PrayerLocation loc) async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setString(_key, loc.name);
    state = loc;
  }
}

final locationProvider = NotifierProvider<LocationNotifier, PrayerLocation>(
  LocationNotifier.new,
);

// ── Settings: prayer calculation method ───────────────────────────────────

/// One selectable adhan calculation method with a human readable label.
class PrayerMethodOption {
  final String id;
  final String label;
  final CalculationMethod method;

  const PrayerMethodOption(this.id, this.label, this.method);

  static const options = <PrayerMethodOption>[
    PrayerMethodOption(
      'karachi',
      'University of Islamic Sciences, Karachi',
      CalculationMethod.karachi,
    ),
    PrayerMethodOption(
      'muslim_world_league',
      'Muslim World League',
      CalculationMethod.muslim_world_league,
    ),
    PrayerMethodOption(
      'egyptian',
      'Egyptian General Authority of Survey',
      CalculationMethod.egyptian,
    ),
    PrayerMethodOption(
      'umm_al_qura',
      'Umm al-Qura University, Makkah',
      CalculationMethod.umm_al_qura,
    ),
    PrayerMethodOption('dubai', 'Dubai (Gulf Region)', CalculationMethod.dubai),
    PrayerMethodOption(
      'moon_sighting_committee',
      'Moonsighting Committee',
      CalculationMethod.moon_sighting_committee,
    ),
    PrayerMethodOption(
      'north_america',
      'ISNA (North America)',
      CalculationMethod.north_america,
    ),
    PrayerMethodOption('kuwait', 'Kuwait', CalculationMethod.kuwait),
    PrayerMethodOption('qatar', 'Qatar', CalculationMethod.qatar),
    PrayerMethodOption('singapore', 'Singapore', CalculationMethod.singapore),
    PrayerMethodOption('turkey', 'Diyanet (Turkey)', CalculationMethod.turkey),
    PrayerMethodOption('tehran', 'Tehran', CalculationMethod.tehran),
  ];

  static PrayerMethodOption byId(String? id) {
    return options.firstWhere((o) => o.id == id, orElse: () => options.first);
  }
}

class PrayerMethodNotifier extends Notifier<PrayerMethodOption> {
  static const _key = 'prayer_method';

  @override
  PrayerMethodOption build() {
    final prefs = ref.watch(sharedPrefsProvider);
    return PrayerMethodOption.byId(prefs.getString(_key));
  }

  Future<void> set(PrayerMethodOption option) async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setString(_key, option.id);
    state = option;
  }
}

final prayerMethodProvider =
    NotifierProvider<PrayerMethodNotifier, PrayerMethodOption>(
      PrayerMethodNotifier.new,
    );

// ── Prayer times (adhan) ──────────────────────────────────────────────────

/// Computed prayer times for the selected day + saved location.
/// Witr is derived as the midpoint between Isha and next-day Fajr.
class PrayerTimesResult {
  final Map<NamazType, DateTime> times;
  const PrayerTimesResult(this.times);
  DateTime? operator [](NamazType p) => times[p];
}

final prayerTimesProvider = Provider.family<PrayerTimesResult, DateTime>((
  ref,
  day,
) {
  final loc = ref.watch(locationProvider);
  final method = ref.watch(prayerMethodProvider);
  final d = DateUtilsExt.dateOnly(day);
  final coords = Coordinates(loc.latitude, loc.longitude);
  final params = method.method.getParameters()..madhab = Madhab.hanafi;
  final date = DateComponents(d.year, d.month, d.day);

  final today = PrayerTimes(coords, date, params);
  // Fajr of the following day, to place Witr after Isha.
  final nextDay = d.add(const Duration(days: 1));
  final next = PrayerTimes(
    coords,
    DateComponents(nextDay.year, nextDay.month, nextDay.day),
    params,
  );

  final witr = today.isha.add(
    Duration(
      milliseconds: next.fajr.difference(today.isha).inMilliseconds ~/ 2,
    ),
  );

  return PrayerTimesResult({
    NamazType.fajr: today.fajr,
    NamazType.zuhr: today.dhuhr,
    NamazType.asr: today.asr,
    NamazType.maghrib: today.maghrib,
    NamazType.isha: today.isha,
    NamazType.witr: witr,
  });
});

/// Formats a time for display using the current locale's 24h preference.
String formatClock(BuildContext context, DateTime t) {
  return MaterialLocalizations.of(context).formatTimeOfDay(
    TimeOfDay.fromDateTime(t),
    alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
  );
}

// ── Selected day (Namaz & Nafl day views) ─────────────────────────────────

class SelectedDayNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateUtilsExt.dateOnly(DateTime.now());
  void set(DateTime d) => state = DateUtilsExt.dateOnly(d);
  void shift(int days) => state = state.add(Duration(days: days));
  void today() => state = DateUtilsExt.dateOnly(DateTime.now());
}

final selectedDayProvider = NotifierProvider<SelectedDayNotifier, DateTime>(
  SelectedDayNotifier.new,
);

// ── Settings: notification toggles ────────────────────────────────────────

/// Persisted on/off switches for the reminder notifications.
class NotificationPrefs {
  final bool prayer;
  final bool roza;
  const NotificationPrefs({required this.prayer, required this.roza});

  NotificationPrefs copyWith({bool? prayer, bool? roza}) =>
      NotificationPrefs(prayer: prayer ?? this.prayer, roza: roza ?? this.roza);
}

class NotificationPrefsNotifier extends Notifier<NotificationPrefs> {
  static const _prayerKey = 'notif_prayer_enabled';
  static const _rozaKey = 'notif_roza_enabled';

  @override
  NotificationPrefs build() {
    final prefs = ref.watch(sharedPrefsProvider);
    return NotificationPrefs(
      prayer: prefs.getBool(_prayerKey) ?? false,
      roza: prefs.getBool(_rozaKey) ?? false,
    );
  }

  Future<void> setPrayer(bool v) async {
    await ref.read(sharedPrefsProvider).setBool(_prayerKey, v);
    state = state.copyWith(prayer: v);
  }

  Future<void> setRoza(bool v) async {
    await ref.read(sharedPrefsProvider).setBool(_rozaKey, v);
    state = state.copyWith(roza: v);
  }
}

final notificationPrefsProvider =
    NotifierProvider<NotificationPrefsNotifier, NotificationPrefs>(
      NotificationPrefsNotifier.new,
    );

// ── Backup service ────────────────────────────────────────────────────────

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(ref.watch(dbProvider));
});
