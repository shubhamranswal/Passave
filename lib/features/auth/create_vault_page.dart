import 'package:flutter/material.dart';
import 'package:passave/features/auth/recovery_key_page.dart';

import '../../core/crypto/key_derivation_service.dart';
import '../../core/crypto/vault_key_cache.dart';
import '../../core/crypto/vault_key_manager_global.dart';
import '../../core/security/biometric_service.dart';
import '../../core/theme/passave_theme.dart';
import '../../features/vault/vault_home_page.dart';

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
      final keyDerivation = KeyDerivationService();
      final vaultKeyManager = vaultKeyManagerGlobal;

      await keyDerivation.generateAndStoreSalt();
      final key = await keyDerivation.deriveKey(_passwordController.text);

      vaultKeyManager.unlock(key);
      await vaultKeyCache.store(key);
      await biometricService.enable();

      final recoveryKey = keyDerivation.generateRecoveryKey();
      await keyDerivation.storeRecoveryKey(recoveryKey);

      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RecoveryKeyPage(
            recoveryKey: recoveryKey,
          ),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const VaultHomePage(),
        ),
      );
    } catch (e) {
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
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Master Password'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Confirm Master Password'),
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
