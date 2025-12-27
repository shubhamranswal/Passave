import 'package:flutter/material.dart';
import 'package:passave/features/auth/recover_vault_page.dart';
import 'package:passave/features/vault/widgets/password_field.dart';

import '../../core/crypto/key_derivation_service.dart';
import '../../core/crypto/vault_key_cache.dart';
import '../../core/crypto/vault_key_manager_global.dart';
import '../../core/crypto/vault_session.dart';
import '../../core/crypto/vault_verifier.dart';
import '../../core/security/biometric_service.dart';
import '../../core/theme/passave_theme.dart';
import '../shell/main_shell.dart';

class UnlockVaultPage extends StatefulWidget {
  const UnlockVaultPage({super.key});

  @override
  State<UnlockVaultPage> createState() => _UnlockVaultPageState();
}

class _UnlockVaultPageState extends State<UnlockVaultPage> {
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

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
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final kdf = KeyDerivationService();
      final derivedKey = await kdf.deriveKey(_passwordController.text);
      final isValid = await vaultVerifier.verify(derivedKey);
      if (!isValid) {
        throw Exception('Incorrect password');
      }

      await vaultKeyManagerGlobal.unlock(derivedKey);
      vaultSession.unlock();
      await vaultKeyCache.store(derivedKey);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (_, __, ___) => const MainShell(),
          transitionsBuilder: (_, anim, __, child) {
            return FadeTransition(
              opacity: anim,
              child: child,
            );
          },
        ),
      );
    } catch (_) {
      setState(() => _error = 'Incorrect master password');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _unlockWithBiometrics() async {
    final available = await biometricService.isAvailable();
    if (!available) return;

    final enabled = await biometricService.isEnabled();
    if (!enabled) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final ok = await biometricService.authenticate();
      if (!ok) {
        throw Exception('Biometric authentication failed');
      }

      final cachedKey = await vaultKeyCache.load();
      if (cachedKey == null) {
        throw Exception('No cached vault key');
      }

      final isValid = await vaultVerifier.verify(cachedKey);
      if (!isValid) {
        throw Exception('Cached vault key invalid');
      }

      vaultKeyManagerGlobal.unlock(cachedKey);
      vaultSession.unlock();

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainShell(),
        ),
      );
    } catch (e) {
      setState(() {
        _error =
            'Biometric unlock failed. Enter master password. ${e.toString()}';
      });
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
              const Icon(Icons.lock, size: 64, color: PassaveTheme.primary),
              const SizedBox(height: 24),
              Text(
                'Unlock Vault',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              PasswordField(
                  controller: _passwordController,
                  label: 'Enter your master password'),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _loading ? null : _unlockVault,
                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text('Unlock'),
                ),
              ),
              const SizedBox(height: 32),
              TextButton(
                onPressed: _unlockWithBiometrics,
                child: const Text('Unlock with Biometrics'),
              ),
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
      ),
    );
  }
}
