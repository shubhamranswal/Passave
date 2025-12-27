import 'package:flutter/material.dart';

import '../../core/theme/passave_theme.dart';

class SecurityOverviewPage extends StatelessWidget {
  const SecurityOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Overview'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            _SecurityCard(
              icon: Icons.lock_outline,
              title: 'Encryption',
              description:
                  'All vault data is encrypted locally using strong encryption (AES-256).\n\n'
                  'Encryption keys never leave your device.',
            ),
            _SecurityCard(
              icon: Icons.password,
              title: 'Master Password',
              description: 'Your master password protects the entire vault.\n\n'
                  'It is never stored and cannot be recovered.',
            ),
            _SecurityCard(
              icon: Icons.vpn_key,
              title: 'Recovery Key',
              description:
                  'A one-time recovery key is generated during setup.\n\n'
                  'It is required if you forget your master password.',
            ),
            _SecurityCard(
              icon: Icons.fingerprint,
              title: 'Biometrics',
              description: 'Biometrics are used only to unlock this device.\n\n'
                  'They never replace your master password.',
            ),
            _SecurityCard(
              icon: Icons.phone_android,
              title: 'Storage',
              description:
                  'Your vault is stored locally on this device only.\n\n'
                  'Deleting the app permanently removes all data.',
            ),
            _SecurityCard(
              icon: Icons.cloud_off,
              title: 'Cloud & Sync',
              description: 'No cloud sync is enabled.\n\n'
                  'Passave works fully offline.',
            ),
          ],
        ),
      ),
    );
  }
}

class _SecurityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _SecurityCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PassaveTheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: PassaveTheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
