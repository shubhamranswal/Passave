import 'package:flutter/material.dart';

import '../../core/crypto/key_derivation_service.dart';
import '../../core/crypto/vault_key_cache.dart';
import '../../core/crypto/vault_key_manager_global.dart';
import '../../core/crypto/vault_verifier.dart';
import '../vault/widgets/password_field.dart';

class ChangeMasterPasswordPage extends StatefulWidget {
  const ChangeMasterPasswordPage({super.key});

  @override
  State<ChangeMasterPasswordPage> createState() =>
      _ChangeMasterPasswordPageState();
}

class _ChangeMasterPasswordPageState extends State<ChangeMasterPasswordPage> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  String? _error;
  bool _loading = false;

  Future<void> _changePassword() async {
    if (_newController.text.length < 8) {
      setState(() => _error = 'New password must be at least 8 characters');
      return;
    }

    if (_newController.text != _confirmController.text) {
      setState(() => _error = 'New passwords do not match');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final kdf = KeyDerivationService();

      final currentKey = await kdf.deriveKey(_currentController.text);

      if (!await vaultKeyManagerGlobal.matches(currentKey)) {
        throw Exception('Incorrect current password');
      }

      final newKey = await kdf.deriveKey(_newController.text);

      await vaultKeyManagerGlobal.unlock(newKey);
      await vaultVerifier.initialize(newKey);
      await vaultKeyCache.clear();
      await vaultKeyCache.store(newKey);

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _error = e.toString().contains('Incorrect')
            ? 'Current password is incorrect'
            : 'Failed to update password';
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Master Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            PasswordField(
              controller: _currentController,
              label: 'Current Master Password',
            ),
            const SizedBox(height: 16),
            PasswordField(
              controller: _newController,
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
                onPressed: _loading ? null : _changePassword,
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text('Update Password'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
