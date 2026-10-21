import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/app_database.dart';
import '../db/daos/khatam_dao.dart';
import '../utils/date_utils_ext.dart';
import 'app_providers.dart';

// ── DAO ───────────────────────────────────────────────────────────────────

final khatamDaoProvider = Provider<KhatamDao>((ref) {
  return ref.watch(dbProvider).khatamDao;
});

// ── Streams ───────────────────────────────────────────────────────────────

/// All khatams, newest first.
final khatamsProvider = StreamProvider<List<Khatam>>((ref) {
  return ref.watch(khatamDaoProvider).watchAll();
});

/// The currently active (unfinished) khatam, if any.
final activeKhatamProvider = StreamProvider<Khatam?>((ref) {
  return ref.watch(khatamDaoProvider).watchActive();
});

/// Done paras (1..30) for one khatam.
final khatamDoneParasProvider = StreamProvider.family<Set<int>, int>((
  ref,
  khatamId,
) {
  return ref.watch(khatamDaoProvider).watchDoneParas(khatamId);
});

// ── Settings: yearly khatam goal ─────────────────────────────────────────

class KhatamGoalNotifier extends Notifier<int> {
  static const _key = 'khatam_yearly_goal';

  @override
  int build() {
    final prefs = ref.watch(sharedPrefsProvider);
    return prefs.getInt(_key) ?? 12;
  }

  Future<void> set(int goal) async {
    final prefs = ref.read(sharedPrefsProvider);
    final clamped = goal < 1 ? 1 : goal;
    await prefs.setInt(_key, clamped);
    state = clamped;
  }
}

final khatamGoalProvider = NotifierProvider<KhatamGoalNotifier, int>(
  KhatamGoalNotifier.new,
);

// ── Counters ──────────────────────────────────────────────────────────────

/// Yearly + all-time khatam counts.
class KhatamCounts {
  final int thisYear;
  final int allTime;

  /// Completed khatams keyed by year (bar-chart source).
  final Map<int, int> byYear;

  const KhatamCounts({
    required this.thisYear,
    required this.allTime,
    required this.byYear,
  });
}

final khatamCountsProvider = FutureProvider<KhatamCounts>((ref) async {
  final dao = ref.watch(khatamDaoProvider);
  final year = DateTime.now().year;
  return KhatamCounts(
    thisYear: await dao.countInYear(year),
    allTime: await dao.countAll(),
    byYear: await dao.completedByYear(),
  );
});

// ── Actions ───────────────────────────────────────────────────────────────

class KhatamActions {
  final KhatamDao _dao;
  const KhatamActions(this._dao);

  Future<void> start(DateTime day) {
    return _dao.startKhatam(startDate: DateUtilsExt.ymd(day));
  }

  Future<void> complete(int id, DateTime day) {
    return _dao.completeKhatam(id, endDate: DateUtilsExt.ymd(day));
  }

  Future<void> setParaDone(
    int khatamId,
    int para, {
    required bool done,
    required DateTime day,
  }) {
    return _dao.setParaDone(
      khatamId,
      para,
      done: done,
      date: DateUtilsExt.ymd(day),
    );
  }

  /// Marks paras 1..[throughPara] done — auto-links to the Tilawat position.
  Future<void> syncThrough(
    int khatamId,
    int throughPara, {
    required DateTime day,
  }) {
    return _dao.markParasThrough(
      khatamId,
      throughPara,
      date: DateUtilsExt.ymd(day),
    );
  }
}

final khatamActionsProvider = Provider<KhatamActions>((ref) {
  return KhatamActions(ref.watch(khatamDaoProvider));
});
