import 'package:flutter/material.dart';

import '../../core/crypto/vault_key_manager_global.dart';
import '../../core/crypto/vault_session.dart';
import '../auth/vault_locked_page.dart';
import '../settings/auto_lock_settings_page.dart';
import '../settings/change_master_password_page.dart';
import '../settings/security_overview_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  void _lockVault(BuildContext context) async {
    vaultKeyManagerGlobal.lock();
    vaultSession.lock();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const VaultLockedPage(),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile header
          Row(
            children: const [
              CircleAvatar(
                radius: 28,
                child: Icon(Icons.person, size: 32),
              ),
              SizedBox(width: 16),
              Text(
                'Local Vault User',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 32),

          _AccountItem(
            icon: Icons.security,
            title: 'Security Overview',
            onTap: (context) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SecurityOverviewPage(),
                ),
              );
            },
          ),
          _AccountItem(
            icon: Icons.lock_reset,
            title: 'Change Master Password',
            onTap: (context) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ChangeMasterPasswordPage(),
                ),
              );
            },
          ),
          _AccountItem(
            icon: Icons.timer,
            title: 'Auto-lock Timeout',
            onTap: (context) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AutoLockSettingsPage(),
                ),
              );
            },
          ),

          const Divider(height: 32),

          _AccountItem(
            icon: Icons.lock,
            title: 'Lock Vault',
            isDestructive: true,
            onTap: _lockVault,
          ),

          const SizedBox(height: 32),

          const Text(
            'Passave · Local-only password manager',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _AccountItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDestructive;
  final void Function(BuildContext) onTap;

  const _AccountItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.red : null;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => onTap(context),
    );
  }
}
