import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RecoveryKeyStorage {
  static const _key = 'recovery_key';
  final _storage = const FlutterSecureStorage();

  Future<void> store(String recoveryKey) async {
    await _storage.write(key: _key, value: recoveryKey);
  }

  Future<String?> read() async {
    return await _storage.read(key: _key);
  }

  Future<void> clear() async {
    await _storage.delete(key: _key);
  }

  Future<bool> exists() async {
    return (await read()) != null;
  }
}

final recoveryKeyStorage = RecoveryKeyStorage();
