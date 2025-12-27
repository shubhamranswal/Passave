import 'package:flutter/widgets.dart';

import '../crypto/vault_key_manager_global.dart';
import 'auto_lock_service.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      vaultKeyManagerGlobal.lock();
      autoLockService.stop();
    }

    if (state == AppLifecycleState.resumed &&
        vaultKeyManagerGlobal.isUnlocked) {
      autoLockService.start();
    }
  }
}
