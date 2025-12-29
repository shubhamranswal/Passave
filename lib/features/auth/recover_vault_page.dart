import 'package:flutter/material.dart';
import 'package:passave/core/utils/widgets/passave_scaffold.dart';
import 'package:passave/features/auth/reset_master_password_page.dart';

import '../../core/crypto/vault/vault_controller.dart';
import '../../core/utils/widgets/passave_button.dart';
import '../../core/utils/widgets/passave_textfield.dart';

class RecoverVaultPage extends StatefulWidget {
  const RecoverVaultPage({super.key});

  @override
  State<RecoverVaultPage> createState() => _RecoverVaultPageState();
}

class _RecoverVaultPageState extends State<RecoverVaultPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  String? _submitError;
  bool _loading = false;

  Future<void> _recover() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _submitError = null;
    });

    final ok =
        await vaultController.unlockWithRecoveryKey(_controller.text.trim());
    if (!ok) {
      setState(() => _submitError = 'Invalid recovery key');
    } else {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ResetMasterPasswordPage(),
        ),
      );
    }

    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PassaveScaffold(
      appBar: AppBar(title: const Text('Recover Vault')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ListView(
              children: [
                const SizedBox(height: 24),
                const Text(
                  'Enter your recovery key',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                PassaveTextField(
                  controller: _controller,
                  hint: 'Paste your recovery key here',
                  icon: Icons.vpn_key,
                  keyboardType: TextInputType.multiline,
                  obscureText: false,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Recovery key cannot be empty';
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
          width: double.infinity,
          height: 52,
          child: PassaveButton(
            loading: _loading,
            onPressed: _recover,
            text: 'Recover Vault',
          ),
        ),
      ),
    );
  }
}
