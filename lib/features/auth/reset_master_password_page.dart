import 'package:flutter/material.dart';
import 'package:passave/features/shell/main_shell.dart';

import '../../core/crypto/key_derivation_service.dart';
import '../../core/crypto/vault_key_cache.dart';
import '../../core/crypto/vault_key_manager_global.dart';
import '../../core/crypto/vault_session.dart';
import '../../core/crypto/vault_verifier.dart';
import '../../core/utils/theme/passave_theme.dart';
import '../../core/utils/widgets/password_field.dart';

class ResetMasterPasswordPage extends StatefulWidget {
  const ResetMasterPasswordPage({super.key});

  @override
  State<ResetMasterPasswordPage> createState() =>
      _ResetMasterPasswordPageState();
}

class _ResetMasterPasswordPageState extends State<ResetMasterPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _loading = false;
  String? _submitError;

  Future<void> _reset() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _submitError = null;
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
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    } catch (_) {
      setState(() => _submitError = 'Failed to reset password');
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Reset Master Password'),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ListView(
                children: [
                  const Icon(
                    Icons.lock_reset,
                    size: 64,
                    color: PassaveTheme.primary,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Set a new master password',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  PasswordField(
                    controller: _passwordController,
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
                  const SizedBox(height: 16),
                  PasswordField(
                    controller: _confirmController,
                    hint: 'Confirm new master password',
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
            child: ElevatedButton(
              onPressed: _loading ? null : _reset,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Reset Password'),
            ),
          ),
        ),
      ),
    );
  }
}
