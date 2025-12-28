import 'dart:async';

import 'package:flutter/material.dart';
import 'package:passave/core/utils/widgets/passave_button.dart';
import 'package:passave/core/utils/widgets/passave_scaffold.dart';
import 'package:passave/core/utils/widgets/security_level_form_field.dart';
import 'package:uuid/uuid.dart';

import '../../core/security/password_strength/password_strength.dart';
import '../../core/utils/widgets/passave_textfield.dart';
import '../../core/utils/widgets/password_field.dart';
import '../../core/utils/widgets/section_title.dart';
import 'models/credential.dart';
import 'models/security_level.dart';
import 'repository/vault_provider.dart';

class AddCredentialPage extends StatefulWidget {
  const AddCredentialPage({super.key});

  @override
  State<AddCredentialPage> createState() => _AddCredentialPageState();
}

class _AddCredentialPageState extends State<AddCredentialPage> {
  final _formKey = GlobalKey<FormState>();

  final _siteController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _notesController = TextEditingController();

  final _uuid = const Uuid();

  bool _isSaving = false;
  bool _showNotes = false;
  SecurityLevel? _securityLevel;

  PasswordStrengthResult? _passwordStrength;
  Timer? _strengthDebounce;
  final _passwordStrengthService = PasswordStrengthService();

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final now = DateTime.now();

    final credential = Credential(
      id: _uuid.v4(),
      site: _siteController.text.trim(),
      username: _usernameController.text.trim(),
      password: _passwordController.text,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      securityLevel: _securityLevel!,
      createdAt: now,
      updatedAt: now,
    );

    await vaultRepository.add(credential);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Credential saved')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return PassaveScaffold(
      appBar: AppBar(title: const Text('Add Credential')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                const SectionTitle(title: 'Website or App'),
                const SizedBox(height: 8),
                PassaveTextField(
                  controller: _siteController,
                  hint: 'example.com',
                  icon: Icons.language,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a website or app name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                const SectionTitle(title: 'Username / Email'),
                const SizedBox(height: 8),
                PassaveTextField(
                  controller: _usernameController,
                  hint: 'username@example.com',
                  icon: Icons.person_outline,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 24),
                const SectionTitle(title: 'Password'),
                const SizedBox(height: 8),
                PasswordField(
                  hint: '',
                  controller: _passwordController,
                  onChanged: (value) {
                    _strengthDebounce?.cancel();

                    _strengthDebounce = Timer(
                      const Duration(milliseconds: 300),
                      () {
                        if (value.trim().isEmpty) {
                          if (!mounted) return;
                          setState(() => _passwordStrength = null);
                          return;
                        }

                        final result = _passwordStrengthService.analyze(value);

                        if (!mounted) return;
                        setState(() => _passwordStrength = result);
                      },
                    );
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    return null;
                  },
                ),
                PasswordStrengthIndicator(
                  result: _passwordStrength,
                ),
                const SizedBox(height: 24),
                const SectionTitle(title: 'Security Level'),
                const SizedBox(height: 12),
                SecurityLevelFormField(
                    initialValue: _securityLevel,
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a security level';
                      }
                      return null;
                    },
                    onChanged: (level) {
                      setState(() {
                        _securityLevel = level;
                      });
                    }),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () {
                    setState(() => _showNotes = !_showNotes);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SectionTitle(title: 'Notes'),
                      Icon(
                        _showNotes ? Icons.expand_less : Icons.expand_more,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _showNotes
                      ? Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: PassaveTextField(
                            controller: _notesController,
                            hint: 'Additional info (2FA, recovery codes, etc.)',
                            icon: Icons.notes_outlined,
                            maxLines: 4,
                            keyboardType: TextInputType.multiline,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 52,
          child: PassaveButton(
            text: _isSaving ? 'Saving Credential' : 'Save Credential',
            onPressed: _isSaving ? () {} : _save,
          ),
        ),
      ),
    );
  }
}
