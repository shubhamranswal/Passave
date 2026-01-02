import 'package:flutter/material.dart';
import 'package:passave/features/shell/account/settings/auto_lock_settings_page.dart';
import 'package:passave/features/shell/account/settings/change_master_password_page.dart';
import 'package:passave/features/shell/account/widgets/biometric_toggle_tile.dart';
import 'package:passave/features/shell/account/widgets/profile_card.dart';

import '../../../core/crypto/vault/vault_controller.dart';
import '../../../core/crypto/vault_key_cache.dart';
import '../../../core/user/user_profile.dart';
import '../../../core/utils/widgets/passave_scaffold.dart';
import 'security_info_page.dart';
import 'widgets/security_status_tile.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  UserProfile? profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final loadedProfile = await userProfileService.load();
    setState(() {
      profile = loadedProfile;
    });
  }

  void _lockVault(BuildContext context) {
    vaultController.lock(reason: 'manual');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final vaultUnlocked = vaultController.status == VaultStatus.unlocked;

    return PassaveScaffold(
        appBar: AppBar(title: const Text('Account')),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const ProfileCard(),
              _section(context, 'Vault Status'),
              _SectionCard(children: [
                SecurityStatusTile(
                  icon: Icons.lock_outline,
                  title: 'Vault',
                  status: vaultUnlocked ? 'Unlocked' : 'Locked',
                  ok: vaultUnlocked,
                ),
                const SizedBox(height: 12),
                const BiometricToggleTile(),
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
              ]),
              _section(context, 'Security Controls'),
              _SectionCard(children: [
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
              ]),
              // const SizedBox(height: 24),
              _section(context, 'Session & Access'),
              _SectionCard(children: [
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
                  title: 'How Passave works',
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
              ]),
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
        ));
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

class _SectionCard extends StatelessWidget {
  final List<Widget> children;

  const _SectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }
}
