import 'package:flutter/material.dart';

import '../vault/models/credential.dart';
import '../vault/models/security_level.dart';
import '../vault/repository/vault_provider.dart';
import '../vault/widgets/vault_item_card.dart';

class HomeOverviewPage extends StatefulWidget {
  const HomeOverviewPage({super.key});

  @override
  State<HomeOverviewPage> createState() => _HomeOverviewPageState();
}

class _HomeOverviewPageState extends State<HomeOverviewPage> {
  late Future<List<Credential>> _credentialsFuture;

  @override
  void initState() {
    super.initState();
    _credentialsFuture = vaultRepository.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<Credential>>(
        future: _credentialsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final credentials = snapshot.data!;
          final recent = credentials.toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          final high = credentials
              .where((c) => c.securityLevel == SecurityLevel.high)
              .length;
          final medium = credentials
              .where((c) => c.securityLevel == SecurityLevel.medium)
              .length;
          final low = credentials
              .where((c) => c.securityLevel == SecurityLevel.low)
              .length;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _VaultHealthCard(
                total: credentials.length,
                high: high,
                medium: medium,
                low: low,
              ),
              const SizedBox(height: 24),
              const Text(
                'Security Distribution',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _SecurityDistributionBar(
                high: high,
                medium: medium,
                low: low,
              ),
              const SizedBox(height: 32),
              const Text(
                'Recently Added',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              if (recent.isEmpty)
                const Text('No credentials yet')
              else
                ...recent.take(5).map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: VaultItemCard(credential: c),
                      ),
                    ),
              const SizedBox(height: 32),
              _SecurityHint(
                total: credentials.length,
                high: high,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _VaultHealthCard extends StatelessWidget {
  final int total;
  final int high;
  final int medium;
  final int low;

  const _VaultHealthCard({
    required this.total,
    required this.high,
    required this.medium,
    required this.low,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Stat(label: 'Total', value: total.toString()),
          _Stat(label: 'High', value: high.toString()),
          _Stat(label: 'Medium', value: medium.toString()),
          _Stat(label: 'Low', value: low.toString()),
        ],
      ),
    );
  }
}

class _SecurityDistributionBar extends StatelessWidget {
  final int high;
  final int medium;
  final int low;

  const _SecurityDistributionBar({
    required this.high,
    required this.medium,
    required this.low,
  });

  @override
  Widget build(BuildContext context) {
    final total = high + medium + low;
    if (total == 0) return const SizedBox();

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          _bar(high, total, Colors.red),
          _bar(medium, total, Colors.orange),
          _bar(low, total, Colors.grey),
        ],
      ),
    );
  }

  Widget _bar(int value, int total, Color color) {
    return Expanded(
      flex: value == 0 ? 1 : value,
      child: Container(
        height: 12,
        color: color,
      ),
    );
  }
}

class _SecurityHint extends StatelessWidget {
  final int total;
  final int high;

  const _SecurityHint({
    required this.total,
    required this.high,
  });

  @override
  Widget build(BuildContext context) {
    if (total == 0) {
      return const Text(
        'Start by adding your first credential.',
        style: TextStyle(fontWeight: FontWeight.w500),
      );
    }

    if (high == 0) {
      return const Text(
        'Tip: Mark sensitive accounts as High security.',
        style: TextStyle(fontWeight: FontWeight.w500),
      );
    }

    return const Text(
      'Your vault is well organized 🔐',
      style: TextStyle(fontWeight: FontWeight.w500),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;

  const _Stat({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
