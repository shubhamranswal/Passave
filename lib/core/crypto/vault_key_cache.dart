import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class VaultKeyCache {
  static const _key = 'vault_key_cache';
  final _storage = const FlutterSecureStorage();

  Future<void> store(SecretKey key) async {
    final bytes = await key.extractBytes();
    await _storage.write(
      key: _key,
      value: bytes.join(','),
    );
  }

  Future<SecretKey?> load() async {
    final data = await _storage.read(key: _key);
    if (data == null) return null;
    final bytes = data.split(',').map(int.parse).toList();
    return SecretKeyData(bytes);
  }

  Future<void> clear() async {
    await _storage.delete(key: _key);
  }
}

final vaultKeyCache = VaultKeyCache();
