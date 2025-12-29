import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KeyDerivationService {
  static const _saltKey = 'vault_salt';
  static const _iterations = 200000;
  static const _keyLength = 32;
  static const _recoveryKeyHashKey = 'recovery_key_hash';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Called ONCE when vault is created
  Future<void> generateAndStoreSalt() async {
    final random = Random.secure();
    final salt = List<int>.generate(16, (_) => random.nextInt(256));
    await _storage.write(
      key: _saltKey,
      value: base64Encode(salt),
    );
  }

  Future<List<int>> _getSalt() async {
    final encoded = await _storage.read(key: _saltKey);
    if (encoded == null) {
      throw Exception('Vault salt not found');
    }
    return base64Decode(encoded);
  }

  /// Derives the Vault Encryption Key from master password
  Future<SecretKey> deriveKey(String masterPassword) async {
    final salt = await _getSalt();

    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: _iterations,
      bits: _keyLength * 8,
    );

    return pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(masterPassword)),
      nonce: salt,
    );
  }

  /// Used to check password correctness
  Future<bool> verifyPassword(
    String masterPassword,
    SecretKey expectedKey,
  ) async {
    final derived = await deriveKey(masterPassword);
    final a = await derived.extractBytes();
    final b = await expectedKey.extractBytes();
    return _constantTimeEquals(a, b);
  }

  bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    int result = 0;
    for (int i = 0; i < a.length; i++) {
      result |= a[i] ^ b[i];
    }
    return result == 0;
  }

  /// Store hashed recovery key (never plaintext)
  Future<void> storeRecoveryKey(String recoveryKey) async {
    final salt = await _getSalt();

    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: _iterations,
      bits: _keyLength * 8,
    );

    final derived = await pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(recoveryKey)),
      nonce: salt,
    );

    final bytes = await derived.extractBytes();
    await _storage.write(
      key: _recoveryKeyHashKey,
      value: base64Encode(bytes),
    );
  }

  /// Verify recovery key & derive vault key
  Future<SecretKey> deriveKeyFromRecoveryKey(String recoveryKey) async {
    final salt = await _getSalt();
    final stored = await _storage.read(key: _recoveryKeyHashKey);

    if (stored == null) {
      throw Exception('Recovery key not set');
    }

    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: _iterations,
      bits: _keyLength * 8,
    );

    final derived = await pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(recoveryKey)),
      nonce: salt,
    );

    final derivedBytes = await derived.extractBytes();
    final storedBytes = base64Decode(stored);

    if (!_constantTimeEquals(derivedBytes, storedBytes)) {
      throw Exception('Invalid recovery key');
    }

    return derived;
  }
}
