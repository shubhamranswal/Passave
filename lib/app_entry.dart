import 'package:flutter/material.dart';
import 'package:passave/features/shell/main_shell.dart';

import 'core/crypto/key_derivation_service.dart';
import 'core/crypto/vault_key_manager_global.dart';
import 'features/auth/create_vault_page.dart';
import 'features/auth/vault_locked_page.dart';

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: KeyDerivationService().vaultExists(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final vaultExists = snapshot.data!;

        if (!vaultExists) {
          return const CreateVaultPage();
        }

        if (!vaultKeyManagerGlobal.isUnlocked) {
          return const VaultLockedPage();
        }

        return const MainShell();
      },
    );
  }
}
