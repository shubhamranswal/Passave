import 'package:flutter/material.dart';
import 'package:passave/core/utils/widgets/passave_button.dart';
import 'package:passave/core/utils/widgets/passave_scaffold.dart';
import 'package:passave/features/auth/recover_vault_page.dart';

import '../../core/crypto/vault/vault_controller.dart';
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
    final ok = await vaultController.unlockWithBiometrics();
    if (ok && mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _unlock() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _submitError = null;
    });

    final ok =
        await vaultController.unlockWithPassword(_passwordController.text);

    if (!mounted) return;

    if (!ok) {
      setState(() {
        _submitError = 'Invalid password';
        _loading = false;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: PassaveScaffold(
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ListView(
                  children: [
                    const Icon(Icons.lock,
                        size: 64, color: PassaveTheme.primary),
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
                    onPressed: _unlock,
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
        ));
  }
}
