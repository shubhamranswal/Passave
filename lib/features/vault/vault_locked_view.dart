import 'package:flutter/material.dart';

import '../../core/theme/passave_theme.dart';

class VaultLockedView extends StatelessWidget {
  final VoidCallback onUnlock;

  const VaultLockedView({
    super.key,
    required this.onUnlock,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: PassaveTheme.surface,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.lock_outline,
                  size: 36,
                  color: PassaveTheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Vault Locked',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Unlock to access your passwords',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PassaveTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: onUnlock,
                  child: const Text(
                    'Unlock Vault',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
