import 'package:flutter/material.dart';

import '../../core/theme/passave_theme.dart';
import 'unlock_vault_page.dart';

class VaultLockedPage extends StatelessWidget {
  const VaultLockedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const UnlockVaultPage(),
                        ),
                      );
                    },
                    child: const Text('Unlock Vault'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
