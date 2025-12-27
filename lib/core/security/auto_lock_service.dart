import 'dart:async';

import 'package:passave/core/security/auto_lock_timeout.dart';

import '../crypto/vault_key_manager_global.dart';
import '../crypto/vault_session.dart';
import 'auto_lock_preferences.dart';

class AutoLockService {
  Timer? _timer;

  Future<void> start() async {
    _timer?.cancel();

    final timeout = await autoLockPreferences.load();
    final duration = timeout.duration;

    if (duration == null) return; // Never auto-lock

    _timer = Timer(duration, _lock);
  }

  Future<void> reset() async {
    await start();
  }

  void stop() {
    _timer?.cancel();
  }

  void _lock() {
    vaultKeyManagerGlobal.lock();
    vaultSession.lock();
  }
}

final autoLockService = AutoLockService();
