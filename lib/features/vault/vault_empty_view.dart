import 'package:flutter/material.dart';

import '../../core/theme/passave_theme.dart';

class VaultEmptyView extends StatelessWidget {
  final VoidCallback onAdd;

  const VaultEmptyView({
    super.key,
    required this.onAdd,
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
                  Icons.vpn_key_off,
                  size: 36,
                  color: PassaveTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No passwords yet',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Add your first credential to get started',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PassaveTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'Add Password',
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
