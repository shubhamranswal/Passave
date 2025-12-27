import 'package:collection/collection.dart';
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

  /// Unlock vault with a derived key
  Future<void> unlock(SecretKey key) async {
    _vaultKey = key;
    _vaultKeyBytes = await key.extractBytes();
  }

  /// Lock vault and wipe key material from memory
  void lock() {
    _vaultKey = null;
    _vaultKeyBytes = null;
  }

  /// Check if another derived key matches the active vault key
  Future<bool> matches(SecretKey other) async {
    if (_vaultKeyBytes == null) return false;
    final otherBytes = await other.extractBytes();
    return const ListEquality().equals(_vaultKeyBytes, otherBytes);
  }
}
