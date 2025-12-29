import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class VaultMetadata {
  static const _existsKey = 'vault_exists';
  final _storage = const FlutterSecureStorage();

  Future<bool> exists() async {
    return (await _storage.read(key: _existsKey)) == 'true';
  }

  Future<void> markExists() async {
    await _storage.write(key: _existsKey, value: 'true');
  }

  Future<void> clear() async {
    await _storage.delete(key: _existsKey);
  }
}

final vaultMetadata = VaultMetadata();
