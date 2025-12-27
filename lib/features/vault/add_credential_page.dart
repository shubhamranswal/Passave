import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme/passave_theme.dart';
import 'models/credential.dart';
import 'repository/vault_provider.dart';
import 'widgets/passave_text_field.dart';
import 'widgets/password_field.dart';
import 'widgets/section_title.dart';
import 'widgets/security_level_selector.dart';

class AddCredentialPage extends StatefulWidget {
  const AddCredentialPage({super.key});

  @override
  State<AddCredentialPage> createState() => _AddCredentialPageState();
}

class _AddCredentialPageState extends State<AddCredentialPage> {
  final _siteController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  SecurityLevel _securityLevel = SecurityLevel.medium;
  final _uuid = const Uuid();

  void _save() async {
    final now = DateTime.now();

    final credential = Credential(
      id: _uuid.v4(),
      site: _siteController.text.trim(),
      username: _usernameController.text.trim(),
      password: _passwordController.text,
      notes: null,
      securityLevel: _securityLevel,
      createdAt: now,
      updatedAt: now,
    );

    await vaultRepository.add(credential);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Credential')),
      body: Padding(
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
                  PasswordField(controller: _passwordController, label: ''),
                  const SizedBox(height: 24),
                  const SectionTitle(title: 'Security Level'),
                  const SizedBox(height: 12),
                  SecurityLevelSelector(
                    onChanged: (level) => _securityLevel = level,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: PassaveTheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Save Credential'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
