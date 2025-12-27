import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class VaultKeyCache {
  final _storage = const FlutterSecureStorage();
  static const _keyCache = 'vault_key_cache';

  Future<void> store(SecretKey key) async {
    final bytes = await key.extractBytes();
    await _storage.write(
      key: _keyCache,
      value: bytes.join(','),
    );
  }

  Future<SecretKey?> load() async {
    final data = await _storage.read(key: _keyCache);
    if (data == null) return null;
    return SecretKey(
      data.split(',').map(int.parse).toList(),
    );
  }

  Future<void> clear() async {
    await _storage.delete(key: _keyCache);
  }
}

final vaultKeyCache = VaultKeyCache();
