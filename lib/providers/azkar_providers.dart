import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/app_database.dart';
import '../db/daos/azkar_dao.dart';
import '../utils/azkar_catalog.dart';
import '../utils/date_utils_ext.dart';
import '../utils/streak_utils.dart';
import 'app_providers.dart';

// ── DAO ───────────────────────────────────────────────────────────────────

final azkarDaoProvider = Provider<AzkarDao>((ref) {
  return ref.watch(dbProvider).azkarDao;
});

// ── Daily counts + custom dhikr ──────────────────────────────────────────

/// Live counts for one day (ymd). Keys are dhikr keys.
final azkarDayProvider = StreamProvider.family<List<AzkarEntry>, String>((
  ref,
  date,
) {
  return ref.watch(azkarDaoProvider).watchDay(date);
});

/// Live custom dhikr definitions.
final azkarCustomProvider = StreamProvider<List<CustomDhikr>>((ref) {
  return ref.watch(azkarDaoProvider).watchCustomDhikrs();
});

// ── Counter preferences ──────────────────────────────────────────────────

/// Keeps the display awake while the tasbeeh counter is open.
class AzkarKeepAwakeNotifier extends Notifier<bool> {
  static const _key = 'azkar_keep_awake';

  @override
  bool build() {
    final prefs = ref.watch(sharedPrefsProvider);
    return prefs.getBool(_key) ?? true;
  }

  Future<void> set(bool value) async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setBool(_key, value);
    state = value;
  }
}

final azkarKeepAwakeProvider = NotifierProvider<AzkarKeepAwakeNotifier, bool>(
  AzkarKeepAwakeNotifier.new,
);

/// Plays a soft system click on every count when enabled.
class AzkarSoundNotifier extends Notifier<bool> {
  static const _key = 'azkar_tap_sound';

  @override
  bool build() {
    final prefs = ref.watch(sharedPrefsProvider);
    return prefs.getBool(_key) ?? false;
  }

  Future<void> set(bool value) async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setBool(_key, value);
    state = value;
  }
}

final azkarSoundProvider = NotifierProvider<AzkarSoundNotifier, bool>(
  AzkarSoundNotifier.new,
);

// ── Actions ───────────────────────────────────────────────────────────────

/// Thin action layer for the Azkar module (auto-saves every tap).
class AzkarActions {
  final AzkarDao _dao;
  const AzkarActions(this._dao);

  Future<void> setCount({
    required DateTime day,
    required String dhikrKey,
    required int count,
    required int target,
  }) {
    return _dao.setCount(
      date: DateUtilsExt.ymd(day),
      dhikrKey: dhikrKey,
      count: count,
      target: target,
    );
  }

  Future<void> increment({
    required DateTime day,
    required String dhikrKey,
    required int target,
    int delta = 1,
  }) {
    return _dao.increment(
      date: DateUtilsExt.ymd(day),
      dhikrKey: dhikrKey,
      target: target,
      delta: delta,
    );
  }

  Future<void> resetDay(DateTime day) {
    return _dao.resetDay(DateUtilsExt.ymd(day));
  }

  Future<void> addCustom({
    required String name,
    String arabicText = '',
    int target = 33,
    String? reminderTime,
  }) {
    return _dao.addCustom(
      name: name,
      arabicText: arabicText,
      target: target,
      reminderTime: reminderTime,
    );
  }

  Future<void> removeCustom(int id) => _dao.deactivateCustom(id);
}

final azkarActionsProvider = Provider<AzkarActions>((ref) {
  return AzkarActions(ref.watch(azkarDaoProvider));
});

// ── Statistics ────────────────────────────────────────────────────────────

/// Aggregated Azkar statistics for a date range.
class AzkarStats {
  /// Sum of counts per dhikr key.
  final Map<String, int> byDhikr;

  /// Sum of all counts per day (bar-chart source).
  final Map<String, int> byDay;

  /// Expected count per dhikr key for the range (target × days).
  final Map<String, int> expectedByDhikr;

  /// Number of calendar days in the range.
  final int daysTotal;

  /// Days where every daily dhikr was completed.
  final int completedDays;

  const AzkarStats({
    required this.byDhikr,
    required this.byDay,
    required this.expectedByDhikr,
    required this.daysTotal,
    required this.completedDays,
  });

  int get totalCount => byDhikr.values.fold(0, (s, v) => s + v);

  /// Sum of expected counts across every dhikr.
  int get expectedTotal => expectedByDhikr.values.fold(0, (s, v) => s + v);

  /// Done counts clamped to each dhikr's expected total.
  int get clampedDone {
    var done = 0;
    for (final entry in expectedByDhikr.entries) {
      final count = byDhikr[entry.key] ?? 0;
      done += count > entry.value ? entry.value : count;
    }
    return done;
  }

  /// Overall completion percentage (0..1), clamped to 100 %.
  double get completion {
    final expected = expectedTotal;
    if (expected == 0) return 0;
    return clampedDone / expected;
  }
}

/// Range-scoped Azkar stats.
final azkarStatsProvider = FutureProvider.family<AzkarStats, DateRange>((
  ref,
  range,
) async {
  final dao = ref.watch(azkarDaoProvider);
  final byDhikr = await dao.totalsByDhikr(range);
  final byDay = await dao.totalsByDay(range);
  final daysTotal = daysInRange(range.startYmd, range.endYmd);

  // Targets snapshot: catalog defaults + custom targets from today's rows.
  final todayRows = await dao.watchDay(range.endYmd).first;
  final targets = <String, int>{
    for (final item in azkarCatalog) item.key: item.defaultTarget,
    for (final row in todayRows)
      if (row.dhikrKey.startsWith('custom:')) row.dhikrKey: row.target,
  };
  final completed = await dao.fullyDoneDays(range, dailyAzkarKeys);

  return AzkarStats(
    byDhikr: byDhikr,
    byDay: byDay,
    expectedByDhikr: {
      for (final entry in targets.entries) entry.key: entry.value * daysTotal,
    },
    daysTotal: daysTotal,
    completedDays: completed.length,
  );
});

/// Current + best streak of days where all daily adhkar were completed.
final azkarStreakProvider = FutureProvider<StreakResult>((ref) async {
  final todayYmd = DateUtilsExt.ymd(DateTime.now());
  ref.watch(azkarDayProvider(todayYmd));
  return ref
      .watch(azkarDaoProvider)
      .streaks(todayYmd: todayYmd, keys: dailyAzkarKeys);
});
