import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/app_database.dart';
import '../db/daos/qaza_dao.dart';
import '../db/enums.dart';
import 'app_providers.dart';

// ── DAO ───────────────────────────────────────────────────────────────────

final qazaDaoProvider = Provider<QazaDao>((ref) {
  return ref.watch(dbProvider).qazaDao;
});

// ── Streams ───────────────────────────────────────────────────────────────

/// Live pending qaza count per prayer type.
final qazaPendingProvider = StreamProvider<Map<NamazType, int>>((ref) {
  return ref.watch(qazaDaoProvider).watchPendingCounts();
});

/// Live full qaza ledger (pending first, newest first).
final qazaHistoryProvider = StreamProvider<List<QazaRecord>>((ref) {
  return ref.watch(qazaDaoProvider).watchAll();
});

// ── Actions ───────────────────────────────────────────────────────────────

class QazaActions {
  final QazaDao _dao;
  const QazaActions(this._dao);

  Future<void> addManual({
    required NamazType prayer,
    required int rakats,
    String? note,
  }) {
    return _dao.addManual(prayer: prayer, rakats: rakats, note: note);
  }

  Future<void> markMadeUp(int id) => _dao.markMadeUp(id);

  Future<void> clearOneRakat(NamazType prayer) => _dao.clearOneRakat(prayer);
}

final qazaActionsProvider = Provider<QazaActions>((ref) {
  return QazaActions(ref.watch(qazaDaoProvider));
});
