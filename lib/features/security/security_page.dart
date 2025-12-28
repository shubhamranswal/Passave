import 'package:flutter/material.dart';

import '../../core/crypto/vault_key_cache.dart';
import '../../core/crypto/vault_key_manager_global.dart';
import '../../core/crypto/vault_session.dart';
import '../../core/security/biometric_service.dart';
import '../../core/utils/widgets/passave_scaffold.dart';
import '../settings/auto_lock_settings_page.dart';
import '../settings/change_master_password_page.dart';
import 'security_info_page.dart';
import 'widgets/security_status_tile.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  void _lockVault(BuildContext context) {
    vaultKeyManagerGlobal.lock();
    vaultSession.lock();
  }

  @override
  Widget build(BuildContext context) {
    final vaultUnlocked =
        vaultKeyManagerGlobal.isUnlocked && !vaultSession.isLocked;

    return PassaveScaffold(
      appBar: AppBar(title: const Text('Security')),
      body: ListView(
        children: [
          _section(context, 'Status'),
          SecurityStatusTile(
            icon: Icons.lock_outline,
            title: 'Vault',
            status: vaultUnlocked ? 'Unlocked' : 'Locked',
            ok: vaultUnlocked,
          ),

          const SizedBox(height: 12),

          FutureBuilder<bool>(
            future: biometricService.isEnabled(),
            builder: (_, snapshot) {
              final enabled = snapshot.data ?? false;
              return SecurityStatusTile(
                icon: Icons.fingerprint,
                title: 'Biometrics',
                status: enabled ? 'Enabled on this device' : 'Disabled',
                ok: enabled,
              );
            },
          ),

          const SizedBox(height: 12),

          FutureBuilder<bool>(
            future: vaultKeyCache.load().then((k) => k != null),
            builder: (_, snapshot) {
              final ok = snapshot.data ?? false;
              return SecurityStatusTile(
                icon: Icons.vpn_key,
                title: 'Recovery Key',
                status: ok ? 'Saved' : 'Not available',
                ok: ok,
              );
            },
          ),

          const SizedBox(height: 24),

          // ===== CONTROLS =====
          _section(context, 'Controls'),
          SecurityStatusTile(
            icon: Icons.password,
            title: 'Change Master Password',
            status: '',
            ok: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ChangeMasterPasswordPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          SecurityStatusTile(
            icon: Icons.timer,
            title: 'Auto-lock',
            status: 'Configure',
            ok: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AutoLockSettingsPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // ===== SESSION =====
          _section(context, 'Session'),
          SecurityStatusTile(
            icon: Icons.lock,
            title: 'Lock Vault',
            status: '',
            ok: false,
            onTap: () => _lockVault(context),
          ),

          const SizedBox(height: 12),

          SecurityStatusTile(
            icon: Icons.info_outline,
            title: 'How security works',
            status: '',
            ok: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SecurityInfoPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          Center(
            child: Text(
              'Passave · Local-only vault',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }
}
