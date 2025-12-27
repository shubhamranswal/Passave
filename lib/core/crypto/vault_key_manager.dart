import 'package:cryptography/cryptography.dart';

class VaultKeyManager {
  SecretKey? _vaultKey;

  bool get isUnlocked => _vaultKey != null;

  SecretKey get key {
    if (_vaultKey == null) {
      throw Exception('Vault is locked');
    }
    return _vaultKey!;
  }

  void unlock(SecretKey key) {
    _vaultKey = key;
  }

  void lock() {
    _vaultKey = null;
  }
}
