import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passave/core/utils/widgets/passave_scaffold.dart';
import 'package:passave/features/shell/vault/repository/vault_provider.dart';

import '../../../core/utils/widgets/section_title.dart';
import 'edit_credential_page.dart';
import 'models/credential.dart';
import 'models/security_level.dart';

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
  late Credential _credential;

  @override
  void initState() {
    super.initState();
    _credential = widget.credential;
  }

  Future<void> _reload() async {
    final fresh = await vaultRepository.getById(_credential.id);

    if (fresh != null && mounted) {
      setState(() => _credential = fresh);
    }
  }

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
    final credential = _credential;

    return PassaveScaffold(
      appBar: AppBar(
        title: const Text('Credential'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditCredentialPage(
                    credential: credential,
                  ),
                ),
              );
              if (updated == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Credential updated.')),
                );
                _reload();
              }
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
              if (credential.notes != null) ...[
                const SectionTitle(title: 'Notes'),
                const SizedBox(height: 8),
                _MetaText(
                  text: '${credential.notes}',
                ),
              ],
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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
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
        color: Theme.of(context).colorScheme.surface,
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
        color: Theme.of(context).colorScheme.surface,
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
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        child: Text(
          level.name.toUpperCase(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
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
