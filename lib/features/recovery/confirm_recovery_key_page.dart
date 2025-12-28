import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passave/core/utils/widgets/passave_button.dart';
import 'package:passave/core/vault/vault_metadata.dart';

import '../../core/crypto/recovery_key_storage.dart';
import '../../core/crypto/vault_key_cache.dart';
import '../../core/crypto/vault_key_manager_global.dart';
import '../../core/crypto/vault_verifier.dart';
import '../../core/security/biometric_service.dart';
import '../../core/utils/theme/passave_theme.dart';
import '../../core/vault/vault_creation_session.dart';
import '../../features/shell/main_shell.dart';

class ConfirmRecoveryKeyPage extends StatefulWidget {
  const ConfirmRecoveryKeyPage({super.key});

  @override
  State<ConfirmRecoveryKeyPage> createState() => _ConfirmRecoveryKeyPageState();
}

class _ConfirmRecoveryKeyPageState extends State<ConfirmRecoveryKeyPage>
    with WidgetsBindingObserver {
  bool _confirmed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_confirmed &&
        (state == AppLifecycleState.inactive ||
            state == AppLifecycleState.detached)) {
      _abortCreation();
    }
  }

  void _abortCreation() async {
    vaultCreationSession.clear();
    await recoveryKeyStorage.clear();
    await vaultKeyCache.clear();
    await vaultMetadata.clear();
  }

  Future<void> _finalizeVault() async {
    final session = vaultCreationSession;
    if (!session.isActive) return;

    final key = session.vaultKey!;
    final recoveryKey = session.recoveryKey!;

    await vaultVerifier.initialize(key);
    await vaultKeyManagerGlobal.unlock(key);
    await vaultKeyCache.clear();
    await vaultKeyCache.store(key);
    await biometricService.enable();
    await recoveryKeyStorage.store(recoveryKey);
    await vaultMetadata.markExists();
    session.clear();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const MainShell(),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final recoveryKey = vaultCreationSession.recoveryKey!;

    return WillPopScope(
      onWillPop: () async {
        _abortCreation();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Save Recovery Key'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.warning, size: 64, color: PassaveTheme.primary),
              const SizedBox(height: 24),
              const Text(
                'This recovery key will be shown only once.',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: SelectableText(
                  recoveryKey,
                  style: const TextStyle(
                    fontSize: 16,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: recoveryKey),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied to clipboard')),
                  );
                },
                icon: const Icon(Icons.copy),
                label: const Text('Copy'),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                value: _confirmed,
                onChanged: (v) => setState(() => _confirmed = v ?? false),
                title: const Text(
                  'I have saved my recovery key securely',
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: PassaveButton(
                  loading: !_confirmed,
                  onPressed: _finalizeVault,
                  text: 'Continue',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
