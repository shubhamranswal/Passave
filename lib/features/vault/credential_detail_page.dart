import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/passave_theme.dart';
import 'edit_credential_page.dart';
import 'models/credential.dart';
import 'widgets/section_title.dart';

class CredentialDetailPage extends StatefulWidget {
  final Credential credential;

  const CredentialDetailPage({
    super.key,
    required this.credential,
  });

  @override
  State<CredentialDetailPage> createState() => _CredentialDetailPageState();
}

class _CredentialDetailPageState extends State<CredentialDetailPage> {
  bool _showPassword = false;

  void _copyToClipboard(String value, String label) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final credential = widget.credential;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Credential'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditCredentialPage(
                    credential: credential,
                  ),
                ),
              );
              Navigator.pop(context); // refresh via VaultHome
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              _HeaderCard(site: credential.site),
              const SizedBox(height: 24),
              const SectionTitle(title: 'Username'),
              const SizedBox(height: 8),
              _CopyField(
                value: credential.username,
                icon: Icons.person_outline,
                onCopy: () => _copyToClipboard(credential.username, 'Username'),
              ),
              const SizedBox(height: 24),
              const SectionTitle(title: 'Password'),
              const SizedBox(height: 8),
              _PasswordViewField(
                value: credential.password,
                visible: _showPassword,
                onToggle: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
                onCopy: () => _copyToClipboard(credential.password, 'Password'),
              ),
              const SizedBox(height: 24),
              const SectionTitle(title: 'Security Level'),
              const SizedBox(height: 12),
              _SecurityLevelBadge(level: credential.securityLevel),
              const SizedBox(height: 24),
              const SectionTitle(title: 'Metadata'),
              const SizedBox(height: 8),
              _MetaText(
                text: 'Created • ${credential.createdAt}',
              ),
              const SizedBox(height: 4),
              _MetaText(
                text: 'Updated • ${credential.updatedAt}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final String site;

  const _HeaderCard({required this.site});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PassaveTheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: PassaveTheme.divider,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.language),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              site,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _CopyField extends StatelessWidget {
  final String value;
  final IconData icon;
  final VoidCallback onCopy;

  const _CopyField({
    required this.value,
    required this.icon,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: PassaveTheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: onCopy,
          ),
        ],
      ),
    );
  }
}

class _PasswordViewField extends StatelessWidget {
  final String value;
  final bool visible;
  final VoidCallback onToggle;
  final VoidCallback onCopy;

  const _PasswordViewField({
    required this.value,
    required this.visible,
    required this.onToggle,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: PassaveTheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_outline, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              visible ? value : '••••••••••••',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          IconButton(
            icon: Icon(
              visible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: onToggle,
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: onCopy,
          ),
        ],
      ),
    );
  }
}

class _SecurityLevelBadge extends StatelessWidget {
  final SecurityLevel level;

  const _SecurityLevelBadge({required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: PassaveTheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        level.name.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MetaText extends StatelessWidget {
  final String text;

  const _MetaText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
