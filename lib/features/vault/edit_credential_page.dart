import 'package:flutter/material.dart';

import '../../core/theme/passave_theme.dart';
import 'models/credential.dart';
import 'repository/vault_provider.dart';
import 'widgets/passave_text_field.dart';
import 'widgets/password_field.dart';
import 'widgets/section_title.dart';
import 'widgets/security_level_selector.dart';

class EditCredentialPage extends StatefulWidget {
  final Credential credential;

  const EditCredentialPage({
    super.key,
    required this.credential,
  });

  @override
  State<EditCredentialPage> createState() => _EditCredentialPageState();
}

class _EditCredentialPageState extends State<EditCredentialPage> {
  late TextEditingController _siteController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late SecurityLevel _securityLevel;

  @override
  void initState() {
    super.initState();
    _siteController = TextEditingController(text: widget.credential.site);
    _usernameController =
        TextEditingController(text: widget.credential.username);
    _passwordController =
        TextEditingController(text: widget.credential.password);
    _securityLevel = widget.credential.securityLevel;
  }

  @override
  void dispose() {
    _siteController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final updatedCredential = widget.credential.copyWith(
      site: _siteController.text.trim(),
      username: _usernameController.text.trim(),
      password: _passwordController.text,
      securityLevel: _securityLevel,
    );

    await vaultRepository.update(updatedCredential);
    Navigator.pop(context);
  }

  void _confirmDelete() {
    showModalBottomSheet(
      context: context,
      backgroundColor: PassaveTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: PassaveTheme.danger,
                size: 36,
              ),
              const SizedBox(height: 16),
              const Text(
                'Delete Credential?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This action cannot be undone.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PassaveTheme.danger,
                      ),
                      onPressed: () async {
                        await vaultRepository.delete(widget.credential.id);
                        Navigator.pop(context); // close sheet
                        Navigator.pop(context); // back to detail
                        Navigator.pop(context); // back to vault
                      },
                      child: const Text('Delete'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Credential'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: PassaveTheme.danger,
            ),
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const SectionTitle(title: 'Website or App'),
                    const SizedBox(height: 8),
                    PassaveTextField(
                      controller: _siteController,
                      hint: 'example.com',
                      icon: Icons.language,
                    ),
                    const SizedBox(height: 24),
                    const SectionTitle(title: 'Username / Email'),
                    const SizedBox(height: 8),
                    PassaveTextField(
                      controller: _usernameController,
                      hint: 'username@example.com',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 24),
                    const SectionTitle(title: 'Password'),
                    const SizedBox(height: 8),
                    PasswordField(
                      controller: _passwordController,
                      label: '',
                    ),
                    const SizedBox(height: 24),
                    const SectionTitle(title: 'Security Level'),
                    const SizedBox(height: 12),
                    SecurityLevelSelector(
                      initialValue: _securityLevel,
                      onChanged: (level) {
                        setState(() {
                          _securityLevel = level;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PassaveTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _saveChanges,
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
