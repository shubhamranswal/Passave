import 'dart:async';

import 'package:passave/core/crypto/vault/vault_controller.dart';
import 'package:passave/core/security/auto_lock/auto_lock_timeout.dart';

import 'auto_lock_preferences.dart';

class AutoLockService {
  Timer? _timer;

  Future<void> start() async {
    _timer?.cancel();

    final timeout = await autoLockPreferences.load();
    final duration = timeout.duration;

    if (duration == null) return; // Never auto-lock

    _timer = Timer(duration, lock);
  }

  Future<void> reset() async {
    await start();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void lock() {
    vaultController.lock(reason: 'auto-lock');
    stop();
  }
}

final autoLockService = AutoLockService();
