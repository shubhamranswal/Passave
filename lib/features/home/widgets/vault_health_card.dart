import 'package:flutter/material.dart';

import '../../vault/models/credential.dart';
import '../../vault/models/security_level.dart';

class VaultHealthCard extends StatelessWidget {
  final List<Credential> credentials;

  const VaultHealthCard({
    super.key,
    required this.credentials,
  });

  @override
  Widget build(BuildContext context) {
    final total = credentials.length;
    final high =
        credentials.where((c) => c.securityLevel == SecurityLevel.high).length;
    final medium = credentials
        .where((c) => c.securityLevel == SecurityLevel.medium)
        .length;
    final low =
        credentials.where((c) => c.securityLevel == SecurityLevel.low).length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vault Health',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _stat('Total', total.toString()),
              _dotStat('High', high, Colors.red),
              _dotStat('Medium', medium, Colors.orange),
              _dotStat('Low', low, Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }

  Widget _dotStat(String label, int value, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              value.toString(),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
