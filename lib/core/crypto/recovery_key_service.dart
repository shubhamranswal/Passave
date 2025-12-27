import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RecoveryKeyService {
  static const _storageKey = 'passave_recovery_key';

  static const _chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  static const _length = 24;

  final _secureStorage = const FlutterSecureStorage();
  final _random = Random.secure();

  String generate() {
    return List.generate(
      _length,
      (_) => _chars[_random.nextInt(_chars.length)],
    ).join();
  }

  Future<void> store(String recoveryKey) async {
    await _secureStorage.write(
      key: _storageKey,
      value: recoveryKey,
    );
  }

  Future<String?> read() async {
    return await _secureStorage.read(key: _storageKey);
  }

  Future<bool> verify(String input) async {
    final stored = await read();
    if (stored == null) return false;

    return input.trim() == stored;
  }

  Future<void> clear() async {
    await _secureStorage.delete(key: _storageKey);
  }

  Future<bool> exists() async {
    return (await read()) != null;
  }
}

final recoveryKeyService = RecoveryKeyService();
