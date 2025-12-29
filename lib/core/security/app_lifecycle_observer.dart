import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:passave/core/security/auto_lock/auto_lock_service.dart';

import '../crypto/vault/vault_controller.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        autoLockService.stop();
        vaultController.lock(reason: 'lifecycle');
        break;

      case AppLifecycleState.resumed:
        autoLockService.start();
        vaultController.onAppResumed();
        break;

      case AppLifecycleState.detached:
        break;

      default:
        break;
    }
  }
}
