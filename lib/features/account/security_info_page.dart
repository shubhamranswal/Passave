import 'package:flutter/material.dart';

import '../../core/utils/theme/passave_theme.dart';

class SecurityInfoPage extends StatelessWidget {
  const SecurityInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('How Security Works')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _IntroCard(),
            const SizedBox(height: 24),
            _SectionTitle('Core Protection'),
            const SizedBox(height: 12),
            const _SecurityCard(
              icon: Icons.lock_outline,
              title: 'Encryption',
              tag: 'Local-only',
              description:
                  'All vault data is encrypted on your device using strong encryption (AES-256).\n\n'
                  'Encryption keys never leave your device.',
            ),
            const _SecurityCard(
              icon: Icons.password,
              title: 'Master Password',
              tag: 'Zero-knowledge',
              description: 'Your master password protects the entire vault.\n\n'
                  'It is never stored and cannot be recovered by Passave.',
            ),
            const SizedBox(height: 24),
            _SectionTitle('Recovery & Access'),
            const SizedBox(height: 12),
            const _SecurityCard(
              icon: Icons.vpn_key,
              title: 'Recovery Key',
              tag: 'One-time',
              description: 'A recovery key is generated once during setup.\n\n'
                  'It is required only if you forget your master password.',
            ),
            const _SecurityCard(
              icon: Icons.fingerprint,
              title: 'Biometrics',
              tag: 'Device-bound',
              description:
                  'Biometrics are used only to unlock the vault on this device.\n\n'
                  'They never replace your master password.',
            ),
            const SizedBox(height: 24),
            _SectionTitle('Data Handling'),
            const SizedBox(height: 12),
            const _SecurityCard(
              icon: Icons.phone_android,
              title: 'Storage',
              tag: 'On-device',
              description:
                  'Your vault is stored locally on this device only.\n\n'
                  'Deleting the app permanently removes all data.',
            ),
            const _SecurityCard(
              icon: Icons.cloud_off,
              title: 'Cloud & Sync',
              tag: 'Disabled',
              description: 'No cloud sync is enabled.\n\n'
                  'Passave works fully offline by design.',
            ),
            const SizedBox(height: 32),
            const _FooterNote(),
          ],
        ),
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_rounded,
              size: 36, color: PassaveTheme.primary),
          const SizedBox(height: 12),
          Text(
            'Your vault. Your control.',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Passave is built with a zero-knowledge, local-first security model.\n'
            'Only you can access your data.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .titleSmall
          ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
    );
  }
}

class _SecurityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String tag;

  const _SecurityCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
                Row(
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(width: 8),
                    _Tag(tag),
                  ],
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

class _Tag extends StatelessWidget {
  final String text;
  const _Tag(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: PassaveTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: PassaveTheme.primary,
        ),
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Security is not a feature.\nIt’s a contract.',
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
