import 'package:flutter/material.dart';

import '../../core/security/password_reuse_analyzer.dart';
import '../../core/security/password_strength.dart';
import '../vault/models/credential.dart';
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
          final recent = credentials.take(5).toList();
          final reused =
              PasswordReuseAnalyzer.reusedPasswordsCount(credentials);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _VaultSummaryCard(
                total: credentials.length,
                weak: _countWeak(credentials),
                reused: reused,
              ),
              const SizedBox(height: 24),
              const Text(
                'Recently Added',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              if (recent.isEmpty)
                const Text('No credentials yet')
              else
                ...recent.map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: VaultItemCard(credential: c),
                  ),
                ),
              const SizedBox(height: 32),
              _SecurityNote(credentials: credentials),
            ],
          );
        },
      ),
    );
  }

  int _countWeak(List<Credential> creds) {
    return creds.where((c) {
      final result = PasswordStrengthAnalyzer.analyze(c.password);
      return result.strength == PasswordStrength.weak;
    }).length;
  }
}

class _VaultSummaryCard extends StatelessWidget {
  final int total;
  final int weak;
  final int reused;

  const _VaultSummaryCard({
    required this.total,
    required this.weak,
    required this.reused,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Stat(label: 'Passwords', value: total.toString()),
          _Stat(label: 'Weak', value: weak.toString()),
          _Stat(label: 'Reused', value: reused.toString()),
        ],
      ),
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

class _SecurityNote extends StatelessWidget {
  final List<Credential> credentials;

  const _SecurityNote({required this.credentials});

  @override
  Widget build(BuildContext context) {
    if (credentials.isEmpty) return const SizedBox();

    final weak = credentials
        .where((c) =>
            PasswordStrengthAnalyzer.analyze(c.password).strength ==
            PasswordStrength.weak)
        .length;

    final reused = PasswordReuseAnalyzer.reusedPasswordsCount(credentials);

    if (weak == 0 && reused == 0) {
      return const Text(
        'Your vault looks strong 👍',
        style: TextStyle(fontWeight: FontWeight.w500),
      );
    }

    return Text(
      '${weak > 0 ? '$weak weak' : ''}'
      '${weak > 0 && reused > 0 ? ', ' : ''}'
      '${reused > 0 ? '$reused reused' : ''} passwords detected.',
      style: const TextStyle(fontWeight: FontWeight.w500),
    );
  }
}
