import 'package:flutter/material.dart';
import 'package:passave/core/crypto/vault/vault_controller.dart';
import 'package:passave/core/utils/widgets/passave_button.dart';

import '../../../../core/crypto/key_derivation_service.dart';
import '../../../../core/crypto/vault_key_cache.dart';
import '../../../../core/crypto/vault_key_manager.dart';
import '../../../../core/crypto/vault_verifier.dart';
import '../../../../core/utils/widgets/password_field.dart';
import '../../../../core/utils/widgets/section_title.dart';

class ChangeMasterPasswordPage extends StatefulWidget {
  const ChangeMasterPasswordPage({super.key});

  @override
  State<ChangeMasterPasswordPage> createState() =>
      _ChangeMasterPasswordPageState();
}

class _ChangeMasterPasswordPageState extends State<ChangeMasterPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _loading = false;
  String? _submitError;

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _submitError = null;
    });

    try {
      final kdf = KeyDerivationService();
      final currentKey = await kdf.deriveKey(_currentController.text);
      final valid = await vaultVerifier.verify(currentKey);
      if (!valid) {
        throw const FormatException('incorrect-current');
      }
      final newKey = await kdf.deriveKey(_newController.text);
      await vaultVerifier.initialize(newKey);
      await vaultKeyManagerGlobal.unlock(newKey);
      await vaultKeyCache.clear();
      await vaultKeyCache.store(newKey);
      vaultController.exitRecovery();

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _submitError = e is FormatException && e.message == 'incorrect-current'
            ? 'Current password is incorrect'
            : 'Failed to update master password';
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Master Password'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ListView(
              children: [
                const SectionTitle(title: 'Current Password'),
                const SizedBox(height: 8),
                PasswordField(
                  controller: _currentController,
                  hint: 'Current master password',
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your current password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                const SectionTitle(title: 'New Password'),
                const SizedBox(height: 8),
                PasswordField(
                  controller: _newController,
                  hint: 'New master password',
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter a new password';
                    }
                    if (value.length < 8) {
                      return 'Use at least 8 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                const SectionTitle(title: 'Confirm New Password'),
                const SizedBox(height: 8),
                PasswordField(
                  controller: _confirmController,
                  hint: 'Confirm new password',
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value != _newController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                if (_submitError != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _submitError!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
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
            loading: _loading,
            onPressed: _changePassword,
            text: 'Update Password',
          ),
        ),
      ),
    );
  }
}
