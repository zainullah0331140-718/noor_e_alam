import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// Lightweight PIN helpers for the private Gheebat notes.
///
/// The PIN is never stored: only `salt` + SHA-256(`salt:pin`) are persisted
/// in shared_preferences. This is a privacy screen, not cryptographic
/// protection of the database.

/// Generates a random 16-byte hex salt.
String generatePinSalt() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}

/// Hashes [pin] with [salt] (hex output).
String hashPin(String pin, String salt) {
  return sha256.convert(utf8.encode('$salt:$pin')).toString();
}

/// Whether [pin] is a well-formed 4–8 digit PIN.
bool isValidPin(String pin) => RegExp(r'^\d{4,8}$').hasMatch(pin);

/// Constant-time-ish comparison of the hashes.
bool pinMatches({
  required String pin,
  required String salt,
  required String expectedHash,
}) {
  final actual = hashPin(pin, salt);
  if (actual.length != expectedHash.length) return false;
  var diff = 0;
  for (var i = 0; i < actual.length; i++) {
    diff |= actual.codeUnitAt(i) ^ expectedHash.codeUnitAt(i);
  }
  return diff == 0;
}
