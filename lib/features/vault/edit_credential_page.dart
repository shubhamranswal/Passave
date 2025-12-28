import 'dart:async';

import 'package:flutter/material.dart';
import 'package:passave/core/utils/widgets/passave_button.dart';
import 'package:passave/core/utils/widgets/passave_scaffold.dart';
import 'package:passave/core/utils/widgets/security_level_form_field.dart';

import '../../core/security/password_strength/password_strength.dart';
import '../../core/utils/theme/passave_theme.dart';
import '../../core/utils/widgets/passave_textfield.dart';
import '../../core/utils/widgets/password_field.dart';
import '../../core/utils/widgets/section_title.dart';
import 'models/credential.dart';
import 'models/security_level.dart';
import 'repository/vault_provider.dart';

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
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _siteController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _notesController;

  bool _passwordChanged = false;
  bool _isSaving = false;
  late SecurityLevel _securityLevel;

  final _passwordStrengthService = PasswordStrengthService();
  PasswordStrengthResult? _passwordStrength;
  Timer? _strengthDebounce;

  @override
  void initState() {
    super.initState();
    _siteController = TextEditingController(text: widget.credential.site);
    _usernameController =
        TextEditingController(text: widget.credential.username);
    _passwordController =
        TextEditingController(text: widget.credential.password);
    _notesController =
        TextEditingController(text: widget.credential.notes ?? '');
    _securityLevel = widget.credential.securityLevel;
  }

  @override
  void dispose() {
    _siteController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _onPasswordChanged(String value) async {
    if (!_passwordChanged && value == widget.credential.password) return;
    _passwordChanged = true;

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
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final updatedCredential = widget.credential.copyWith(
      site: _siteController.text.trim(),
      username: _usernameController.text.trim(),
      password: _passwordController.text,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      securityLevel: _securityLevel,
      updatedAt: DateTime.now(),
    );

    await vaultRepository.update(updatedCredential);

    if (!mounted) return;
    Navigator.pop(context);
  }

  void _confirmDelete() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                    child: PassaveButton(
                      onPressed: () => Navigator.pop(context),
                      text: 'Cancel',
                      isPrimary: false,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PassaveButton(
                      onPressed: () async {
                        await vaultRepository.delete(widget.credential.id);
                        if (!mounted) return;
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      text: 'Delete',
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
    return PassaveScaffold(
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
                      return 'Website or app name is required';
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
                  controller: _passwordController,
                  hint: '',
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    return null;
                  },
                  onChanged: _onPasswordChanged,
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
                const SectionTitle(title: 'Notes'),
                const SizedBox(height: 8),
                PassaveTextField(
                  controller: _notesController,
                  hint: 'Additional info (2FA, recovery codes, etc.)',
                  icon: Icons.notes_outlined,
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
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
            text: _isSaving ? 'Saving Changes' : 'Save Changes',
            onPressed: _isSaving ? () {} : _saveChanges,
          ),
        ),
      ),
    );
  }
}
