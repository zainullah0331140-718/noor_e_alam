import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/enums.dart';
import '../db/seed_service.dart';
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
  const PrayerLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
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

// ── Prayer times (adhan) ──────────────────────────────────────────────────

/// Computed prayer times for the selected day + saved location.
/// Witr is derived as the midpoint between Isha and next-day Fajr.
class PrayerTimesResult {
  final Map<NamazType, DateTime> times;
  const PrayerTimesResult(this.times);
  DateTime? operator [](NamazType p) => times[p];
}

final prayerTimesProvider = Provider.family<PrayerTimesResult, DateTime>(
  (ref, day) {
    final loc = ref.watch(locationProvider);
    final d = DateUtilsExt.dateOnly(day);
    final coords = Coordinates(loc.latitude, loc.longitude);
    final params = CalculationMethod.karachi.getParameters()
      ..madhab = Madhab.hanafi;
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
  },
);

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
