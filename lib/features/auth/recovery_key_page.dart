import 'package:flutter/material.dart';

import '../../core/theme/passave_theme.dart';

class RecoveryKeyPage extends StatelessWidget {
  final String recoveryKey;

  const RecoveryKeyPage({
    super.key,
    required this.recoveryKey,
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
              const Icon(Icons.vpn_key, size: 64, color: PassaveTheme.primary),
              const SizedBox(height: 24),
              Text(
                'Your Recovery Key',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              const Text(
                'Save this key securely.\nIt will NOT be shown again.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: PassaveTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SelectableText(
                  recoveryKey,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('I have saved it'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
