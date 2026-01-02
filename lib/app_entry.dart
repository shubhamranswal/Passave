import 'package:flutter/material.dart';
import 'package:passave/features/auth/recover_vault_page.dart';
import 'package:passave/features/onboarding/create_profile_page.dart';

import 'core/crypto/vault/vault_controller.dart';
import 'core/crypto/vault/vault_metadata.dart';
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
        if (snapshot.data != true) {
          return const CreateProfilePage();
        }
        return AnimatedBuilder(
          animation: vaultController,
          builder: (_, __) {
            switch (vaultController.status) {
              case VaultStatus.unlocked:
                return const MainShell();
              case VaultStatus.locked:
                return const VaultLockedPage();
              case VaultStatus.recovery:
                return const RecoverVaultPage();
            }
          },
        );
      },
    );
  }
}
