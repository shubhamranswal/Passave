import 'package:flutter/material.dart';
import 'package:passave/features/auth/reset_master_password_page.dart';

import '../../core/crypto/key_derivation_service.dart';
import '../../core/crypto/vault_key_manager_global.dart';
import '../../core/crypto/vault_session.dart';

class RecoverVaultPage extends StatefulWidget {
  const RecoverVaultPage({super.key});

  @override
  State<RecoverVaultPage> createState() => _RecoverVaultPageState();
}

class _RecoverVaultPageState extends State<RecoverVaultPage> {
  final _controller = TextEditingController();
  String? _error;
  bool _loading = false;

  Future<void> _recover() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final service = KeyDerivationService();
      final key =
          await service.deriveKeyFromRecoveryKey(_controller.text.trim());

      await vaultKeyManagerGlobal.unlock(key);
      vaultSession.enterRecovery();

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ResetMasterPasswordPage(),
        ),
      );
    } catch (_) {
      setState(() => _error = 'Invalid recovery key');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recover Vault')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Enter your recovery key',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Recovery Key'),
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
                onPressed: _loading ? null : _recover,
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text('Recover Vault'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
