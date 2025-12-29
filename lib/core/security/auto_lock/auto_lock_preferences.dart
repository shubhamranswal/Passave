import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auto_lock_timeout.dart';

class AutoLockPreferences {
  static const _key = 'auto_lock_timeout';
  final _storage = const FlutterSecureStorage();

  Future<void> save(AutoLockTimeout timeout) async {
    await _storage.write(key: _key, value: timeout.name);
  }

  Future<AutoLockTimeout> load() async {
    final value = await _storage.read(key: _key);
    return AutoLockTimeout.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AutoLockTimeout.fiveMinutes, // default
    );
  }
}

final autoLockPreferences = AutoLockPreferences();
