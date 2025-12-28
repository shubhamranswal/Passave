import 'package:flutter/material.dart';

import '../../features/auth/vault_locked_page.dart';
import '../crypto/vault_key_manager_global.dart';
import '../crypto/vault_session.dart';

class VaultLockListener extends StatefulWidget {
  final Widget child;

  const VaultLockListener({super.key, required this.child});

  @override
  State<VaultLockListener> createState() => _VaultLockListenerState();
}

class _VaultLockListenerState extends State<VaultLockListener> {
  bool _lockVisible = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkLock();
  }

  @override
  void didUpdateWidget(covariant VaultLockListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    _checkLock();
  }

  void _checkLock() {
    final locked = !vaultKeyManagerGlobal.isUnlocked || vaultSession.isLocked;

    if (locked && !_lockVisible) {
      _lockVisible = true;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final unlocked = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => const VaultLockedPage(),
          ),
        );

        if (unlocked == true && mounted) {
          setState(() {
            _lockVisible = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
