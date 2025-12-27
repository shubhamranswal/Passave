import 'dart:convert';

import 'package:cryptography/cryptography.dart';

import 'vault_key_manager.dart';

class EncryptionService {
  final VaultKeyManager _keyManager;
  final _algorithm = AesGcm.with256bits();

  EncryptionService(this._keyManager);

  Future<String> encrypt(String plaintext) async {
    final nonce = _algorithm.newNonce();
    final secretBox = await _algorithm.encrypt(
      utf8.encode(plaintext),
      secretKey: _keyManager.key,
      nonce: nonce,
    );

    return base64Encode(
      nonce + secretBox.cipherText + secretBox.mac.bytes,
    );
  }

  Future<String> decrypt(String encrypted) async {
    final bytes = base64Decode(encrypted);

    final nonce = bytes.sublist(0, 12);
    final cipherText = bytes.sublist(12, bytes.length - 16);
    final mac = Mac(bytes.sublist(bytes.length - 16));

    final secretBox = SecretBox(
      cipherText,
      nonce: nonce,
      mac: mac,
    );

    final clearText = await _algorithm.decrypt(
      secretBox,
      secretKey: _keyManager.key,
    );

    return utf8.decode(clearText);
  }
}
