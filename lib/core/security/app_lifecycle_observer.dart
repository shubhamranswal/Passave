import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:passave/core/security/auto_lock/auto_lock_service.dart';

import '../crypto/vault/vault_controller.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;

      case AppLifecycleState.paused:
        autoLockService.start();
        break;

      case AppLifecycleState.resumed:
        autoLockService.stop();
        vaultController.onAppResumed();
        break;

      case AppLifecycleState.detached:
        autoLockService.lock();
        break;

      case AppLifecycleState.hidden:
        break;

      default:
        break;
    }
  }
}
