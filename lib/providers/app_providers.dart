import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../db/app_database.dart';

final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize in main');
});

final dbProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

enum DashboardRange { today, month, year }

class DashboardRangeNotifier extends Notifier<DashboardRange> {
  @override
  DashboardRange build() => DashboardRange.today;
  void set(DashboardRange r) => state = r;
}

final dashboardRangeProvider =
    NotifierProvider<DashboardRangeNotifier, DashboardRange>(
      DashboardRangeNotifier.new,
    );

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const _key = 'theme_mode';
  @override
  ThemeMode build() {
    final prefs = ref.watch(sharedPrefsProvider);
    final v = prefs.getString(_key);
    if (v == 'light') return ThemeMode.light;
    if (v == 'dark') return ThemeMode.dark;
    return ThemeMode.system;
  }

  Future<void> set(ThemeMode m) async {
    final prefs = ref.read(sharedPrefsProvider);
    String s;
    if (m == ThemeMode.light) {
      s = 'light';
    } else if (m == ThemeMode.dark) {
      s = 'dark';
    } else {
      s = 'system';
    }
    await prefs.setString(_key, s);
    state = m;
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class LocaleNotifier extends Notifier<Locale?> {
  static const _key = 'app_locale';
  @override
  Locale? build() {
    final prefs = ref.watch(sharedPrefsProvider);
    final code = prefs.getString(_key);
    if (code == null || code.isEmpty) return null;
    return Locale(code);
  }

  Future<void> setLocale(String? code) async {
    final prefs = ref.read(sharedPrefsProvider);
    if (code == null || code.isEmpty) {
      await prefs.remove(_key);
      state = null;
    } else {
      await prefs.setString(_key, code);
      state = Locale(code);
    }
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(
  LocaleNotifier.new,
);

class NumeralsNotifier extends Notifier<bool> {
  static const _key = 'use_eastern_numerals';
  @override
  bool build() {
    final prefs = ref.watch(sharedPrefsProvider);
    return prefs.getBool(_key) ?? false;
  }

  Future<void> set(bool v) async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setBool(_key, v);
    state = v;
  }

  Future<void> toggle() async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setBool(_key, !state);
    state = !state;
  }
}

final numeralsProvider = NotifierProvider<NumeralsNotifier, bool>(
  NumeralsNotifier.new,
);
