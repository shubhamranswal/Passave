import 'package:flutter/material.dart';
import 'package:passave/core/utils/widgets/passave_button.dart';
import 'package:passave/features/auth/recover_vault_page.dart';

import '../../core/crypto/key_derivation_service.dart';
import '../../core/crypto/vault_key_cache.dart';
import '../../core/crypto/vault_key_manager_global.dart';
import '../../core/crypto/vault_session.dart';
import '../../core/crypto/vault_verifier.dart';
import '../../core/security/biometric_service.dart';
import '../../core/utils/theme/passave_theme.dart';
import '../../core/utils/widgets/password_field.dart';

class UnlockVaultPage extends StatefulWidget {
  const UnlockVaultPage({super.key});

  @override
  State<UnlockVaultPage> createState() => _UnlockVaultPageState();
}

class _UnlockVaultPageState extends State<UnlockVaultPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  bool _loading = false;
  String? _submitError;

  @override
  void initState() {
    super.initState();
    _tryBiometric();
  }

  Future<void> _tryBiometric() async {
    if (await biometricService.isEnabled() &&
        await biometricService.isAvailable()) {
      await _unlockWithBiometrics();
    }
  }

  Future<void> _unlockVault() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _submitError = null;
    });

    try {
      final kdf = KeyDerivationService();
      final derivedKey = await kdf.deriveKey(_passwordController.text);

      final isValid = await vaultVerifier.verify(derivedKey);
      if (!isValid) throw Exception();

      vaultKeyManagerGlobal.unlock(derivedKey);
      vaultSession.unlock();
      await vaultKeyCache.store(derivedKey);

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (_) {
      setState(() => _submitError = 'Incorrect master password');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _unlockWithBiometrics() async {
    setState(() {
      _loading = true;
      _submitError = null;
    });

    try {
      final ok = await biometricService.authenticate();
      if (!ok) throw Exception();

      final cachedKey = await vaultKeyCache.load();
      if (cachedKey == null) throw Exception();

      final isValid = await vaultVerifier.verify(cachedKey);
      if (!isValid) throw Exception();

      vaultKeyManagerGlobal.unlock(cachedKey);
      vaultSession.unlock();

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (_) {
      setState(() {
        _submitError = 'Biometric unlock failed. Enter master password.';
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
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
                const Icon(Icons.lock, size: 64, color: PassaveTheme.primary),
                const SizedBox(height: 24),
                Text(
                  'Unlock Vault',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                PasswordField(
                  controller: _passwordController,
                  hint: 'Enter your master password',
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your master password';
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 52,
              child: PassaveButton(
                loading: _loading,
                onPressed: _unlockVault,
                text: 'Unlock Vault',
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RecoverVaultPage(),
                  ),
                );
              },
              child: const Text(
                'Forgot master password?',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
