import 'package:flutter/material.dart';

import 'core/crypto/vault_key_manager_global.dart';
import 'core/vault/vault_metadata.dart';
import 'features/auth/create_vault_page.dart';
import 'features/auth/vault_locked_page.dart';
import 'features/shell/main_shell.dart';

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: vaultMetadata.exists(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final vaultExists = snapshot.data ?? false;
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
