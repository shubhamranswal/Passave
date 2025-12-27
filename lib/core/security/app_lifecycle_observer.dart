import 'package:flutter/widgets.dart';
import 'package:passave/core/crypto/vault_session.dart';

import '../crypto/vault_key_manager_global.dart';
import 'auto_lock_service.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      vaultKeyManagerGlobal.lock();
      vaultSession.lock();
      autoLockService.stop();
    }

    if (state == AppLifecycleState.resumed &&
        vaultKeyManagerGlobal.isUnlocked) {
      autoLockService.start();
    }
  }
}
