import 'package:flutter/material.dart';

import 'core/security/vault_lock_listener.dart';
import 'core/vault/vault_metadata.dart';
import 'features/auth/create_vault_page.dart';
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
        return const VaultLockListener(
          child: MainShell(),
        );
      },
    );
  }
}
