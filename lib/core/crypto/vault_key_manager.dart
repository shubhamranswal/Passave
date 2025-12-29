import 'package:cryptography/cryptography.dart';

class VaultKeyManager {
  SecretKey? _vaultKey;
  List<int>? _vaultKeyBytes;

  bool get isUnlocked => _vaultKey != null;

  SecretKey get key {
    if (_vaultKey == null) {
      throw Exception('Vault is locked');
    }
    return _vaultKey!;
  }

  Future<void> unlock(SecretKey key) async {
    _vaultKey = key;
    _vaultKeyBytes = await key.extractBytes();
  }

  void lock() {
    _vaultKey = null;
    _vaultKeyBytes = null;
  }
}

final vaultKeyManagerGlobal = VaultKeyManager();
