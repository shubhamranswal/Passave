import 'package:flutter/material.dart';
import 'package:passave/core/crypto/recovery_key_service.dart';
import 'package:passave/core/vault/vault_creation_session.dart';

import '../../core/crypto/key_derivation_service.dart';
import '../../core/theme/passave_theme.dart';
import '../recovery/confirm_recovery_key_page.dart';
import '../vault/widgets/password_field.dart';

class CreateVaultPage extends StatefulWidget {
  const CreateVaultPage({super.key});

  @override
  State<CreateVaultPage> createState() => _CreateVaultPageState();
}

class _CreateVaultPageState extends State<CreateVaultPage> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _loading = false;
  String? _error;

  Future<void> _createVault() async {
    if (_passwordController.text.length < 8) {
      setState(() => _error = 'Password must be at least 8 characters');
      return;
    }

    if (_passwordController.text != _confirmController.text) {
      setState(() => _error = 'Passwords do not match');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
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
      setState(() => _error = 'Failed to create vault');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline,
                  size: 64, color: PassaveTheme.primary),
              const SizedBox(height: 24),
              Text(
                'Create Your Vault',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'This password encrypts all your data.\nWe cannot recover it for you.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              PasswordField(
                controller: _passwordController,
                label: 'New Master Password',
              ),
              const SizedBox(height: 16),
              PasswordField(
                controller: _confirmController,
                label: 'Confirm New Master Password',
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _loading ? null : _createVault,
                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text('Create Vault'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
