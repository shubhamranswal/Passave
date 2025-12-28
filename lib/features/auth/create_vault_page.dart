import 'package:flutter/material.dart';
import 'package:passave/core/crypto/recovery_key_service.dart';
import 'package:passave/core/utils/widgets/passave_button.dart';
import 'package:passave/core/vault/vault_creation_session.dart';

import '../../core/crypto/key_derivation_service.dart';
import '../../core/utils/theme/passave_theme.dart';
import '../../core/utils/widgets/password_field.dart';
import '../recovery/confirm_recovery_key_page.dart';

class CreateVaultPage extends StatefulWidget {
  const CreateVaultPage({super.key});

  @override
  State<CreateVaultPage> createState() => _CreateVaultPageState();
}

class _CreateVaultPageState extends State<CreateVaultPage> {
  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _loading = false;
  String? _submitError;

  Future<void> _createVault() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _submitError = null;
    });

    try {
      final kdf = KeyDerivationService();

      await kdf.generateAndStoreSalt();
      final vaultKey = await kdf.deriveKey(_passwordController.text);
      final recoveryKey = recoveryKeyService.generate();

      vaultCreationSession.start(
        key: vaultKey,
        recoveryKey: recoveryKey,
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ConfirmRecoveryKeyPage(),
        ),
      );
    } catch (_) {
      setState(() => _submitError = 'Failed to create vault');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ListView(
              children: [
                const Icon(
                  Icons.lock_outline,
                  size: 64,
                  color: PassaveTheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Create Your Vault',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'This password encrypts all your data.\nWe cannot recover it for you.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                PasswordField(
                  controller: _passwordController,
                  hint: 'New master password',
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter a master password';
                    }
                    if (value.length < 8) {
                      return 'Use at least 8 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                PasswordField(
                  controller: _confirmController,
                  hint: 'Confirm master password',
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value != _passwordController.text) {
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
                    textAlign: TextAlign.center,
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
            text: 'Create Vault',
            loading: _loading,
            onPressed: _createVault,
          ),
        ),
      ),
    );
  }
}
