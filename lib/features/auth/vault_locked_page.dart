import 'package:flutter/material.dart';
import 'package:passave/core/utils/widgets/passave_scaffold.dart';

import '../../core/utils/theme/passave_theme.dart';
import '../../core/utils/widgets/passave_button.dart';
import 'unlock_vault_page.dart';

class VaultLockedPage extends StatelessWidget {
  const VaultLockedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: PassaveScaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock_rounded,
                    size: 72,
                    color: PassaveTheme.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Vault Locked',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your data is encrypted and secure',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: PassaveButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const UnlockVaultPage(),
                          ),
                        );
                      },
                      text: 'Unlock',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
