import 'package:flutter/material.dart';

import '../../core/crypto/key_derivation_service.dart';
import '../../core/crypto/vault_key_cache.dart';
import '../../core/crypto/vault_key_manager_global.dart';
import '../../core/security/biometric_service.dart';
import '../../core/theme/passave_theme.dart';
import '../../features/vault/vault_home_page.dart';

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
      final keyDerivation = KeyDerivationService();
      final vaultKeyManager = vaultKeyManagerGlobal;

      final key = await keyDerivation.deriveKey(_passwordController.text);
      vaultKeyManager.unlock(key);

      await vaultKeyCache.store(key);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (_, __, ___) => const VaultHomePage(),
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
    debugPrint('① biometric flow started');

    final available = await biometricService.isAvailable();
    debugPrint('② biometric available = $available');
    if (!available) return;

    final enabled = await biometricService.isEnabled();
    debugPrint('③ biometric enabled = $enabled');
    if (!enabled) return;

    debugPrint('④ calling authenticate()');
    final ok = await biometricService.authenticate();
    debugPrint('⑤ authenticate result = $ok');
    if (!ok) return;

    final cachedKey = await vaultKeyCache.load();
    debugPrint('⑥ cached key exists = ${cachedKey != null}');
    if (cachedKey == null) return;

    vaultKeyManagerGlobal.unlock(cachedKey);
    debugPrint('⑦ vault unlocked');

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const VaultHomePage(),
      ),
    );
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
              const Text(
                'Enter your master password to unlock',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Master Password'),
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
            ],
          ),
        ),
      ),
    );
  }
}
