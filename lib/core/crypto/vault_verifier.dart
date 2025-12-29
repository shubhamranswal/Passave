import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class VaultVerifier {
  static const _storageKey = 'vault_verifier';
  static const _magic = 'PASSAVE_VAULT_OK';

  final _storage = const FlutterSecureStorage();
  final _cipher = AesGcm.with256bits();

  Future<void> initialize(SecretKey key) async {
    final secretBox = await _cipher.encrypt(
      utf8.encode(_magic),
      secretKey: key,
    );

    final encoded = base64Encode(secretBox.concatenation());
    await _storage.write(
      key: _storageKey,
      value: encoded,
    );
  }

  Future<bool> verify(SecretKey key) async {
    final encoded = await _storage.read(key: _storageKey);
    if (encoded == null) return false;

    try {
      final bytes = base64Decode(encoded);
      final secretBox =
          SecretBox.fromConcatenation(bytes, nonceLength: 12, macLength: 16);

      final decrypted = await _cipher.decrypt(
        secretBox,
        secretKey: key,
      );

      return utf8.decode(decrypted) == _magic;
    } catch (_) {
      return false;
    }
  }
}

final vaultVerifier = VaultVerifier();
