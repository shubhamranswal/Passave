import 'package:flutter/material.dart';
import 'package:passave/features/shell/main_shell.dart';

import '../../core/crypto/key_derivation_service.dart';
import '../../core/crypto/vault_key_cache.dart';
import '../../core/crypto/vault_key_manager_global.dart';
import '../../core/crypto/vault_session.dart';
import '../../core/crypto/vault_verifier.dart';
import '../../core/theme/passave_theme.dart';
import '../vault/widgets/password_field.dart';

class ResetMasterPasswordPage extends StatefulWidget {
  const ResetMasterPasswordPage({super.key});

  @override
  State<ResetMasterPasswordPage> createState() =>
      _ResetMasterPasswordPageState();
}

class _ResetMasterPasswordPageState extends State<ResetMasterPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  String? _error;
  bool _loading = false;

  Future<void> _reset() async {
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
      final newKey = await kdf.deriveKey(_passwordController.text);
      await vaultKeyManagerGlobal.unlock(newKey);
      await vaultVerifier.initialize(newKey);
      await vaultKeyCache.clear();
      await vaultKeyCache.store(newKey);
      vaultSession.exitRecovery();

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainShell(),
        ),
      );
    } catch (_) {
      setState(() => _error = 'Failed to reset password');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // 🔒 NO BACK
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Reset Master Password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_reset,
                  size: 64, color: PassaveTheme.primary),
              const SizedBox(height: 24),
              const Text(
                'Set a new master password',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
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
                  onPressed: _loading ? null : _reset,
                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text('Reset Password'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
