import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/app_lock.dart';
import 'app_providers.dart';

/// Persisted PIN configuration for the private Gheebat section.
class AppLockConfig {
  final bool enabled;
  final String salt;
  final String hash;

  const AppLockConfig({
    required this.enabled,
    required this.salt,
    required this.hash,
  });
}

class AppLockNotifier extends Notifier<AppLockConfig> {
  static const _saltKey = 'gheebat_lock_salt';
  static const _hashKey = 'gheebat_lock_hash';

  @override
  AppLockConfig build() {
    final prefs = ref.watch(sharedPrefsProvider);
    final salt = prefs.getString(_saltKey) ?? '';
    final hash = prefs.getString(_hashKey) ?? '';
    return AppLockConfig(
      enabled: salt.isNotEmpty && hash.isNotEmpty,
      salt: salt,
      hash: hash,
    );
  }

  /// Enables PIN protection (overwrites any previous PIN).
  Future<void> setPin(String pin) async {
    final prefs = ref.read(sharedPrefsProvider);
    final salt = generatePinSalt();
    final hash = hashPin(pin, salt);
    await prefs.setString(_saltKey, salt);
    await prefs.setString(_hashKey, hash);
    state = AppLockConfig(enabled: true, salt: salt, hash: hash);
    ref.read(appUnlockedProvider.notifier).unlock();
  }

  /// Removes PIN protection after verifying [pin].
  Future<bool> removePin(String pin) async {
    if (!verify(pin)) return false;
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.remove(_saltKey);
    await prefs.remove(_hashKey);
    state = const AppLockConfig(enabled: false, salt: '', hash: '');
    ref.read(appUnlockedProvider.notifier).unlock();
    return true;
  }

  bool verify(String pin) {
    if (!state.enabled) return true;
    return pinMatches(pin: pin, salt: state.salt, expectedHash: state.hash);
  }
}

final appLockProvider = NotifierProvider<AppLockNotifier, AppLockConfig>(
  AppLockNotifier.new,
);

/// In-memory unlock state for the current app session.
class AppUnlockedNotifier extends Notifier<bool> {
  @override
  bool build() {
    final lock = ref.watch(appLockProvider);
    return !lock.enabled;
  }

  void unlock() => state = true;

  void lock() => state = false;
}

final appUnlockedProvider = NotifierProvider<AppUnlockedNotifier, bool>(
  AppUnlockedNotifier.new,
);
