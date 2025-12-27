import 'dart:async';

import '../crypto/vault_key_manager_global.dart';

class AutoLockService {
  static const Duration defaultTimeout = Duration(minutes: 5);

  Timer? _timer;

  void start({Duration timeout = defaultTimeout}) {
    _timer?.cancel();
    _timer = Timer(timeout, _lock);
  }

  void reset() {
    _timer?.cancel();
    _timer = Timer(defaultTimeout, _lock);
  }

  void stop() {
    _timer?.cancel();
  }

  void _lock() {
    vaultKeyManagerGlobal.lock();
  }
}

final autoLockService = AutoLockService();
