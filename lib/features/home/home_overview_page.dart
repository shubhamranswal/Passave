import 'package:flutter/material.dart';
import 'package:passave/features/home/widgets/recent_toggle.dart';
import 'package:passave/features/home/widgets/security_distribution_bar.dart';
import 'package:passave/features/home/widgets/security_legend_sheet.dart';
import 'package:passave/features/home/widgets/vault_health_card.dart';
import 'package:passave/features/home/widgets/vault_score_badge.dart';

import '../../core/security/vault_score.dart';
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
  RecentSortMode _sortMode = RecentSortMode.created;

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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load vault'));
          }

          final credentials = snapshot.data!;
          final sorted = [...credentials]..sort((a, b) {
              if (_sortMode == RecentSortMode.created) {
                return b.createdAt.compareTo(a.createdAt);
              }
              return b.updatedAt.compareTo(a.updatedAt);
            });
          final recent = sorted.take(5).toList();
          final score = calculateVaultScore(credentials);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              VaultHealthCard(
                credentials: credentials,
              ),
              const SizedBox(height: 24),
              VaultScoreBadge(
                score: score.score,
                label: score.label,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Security Distribution',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        builder: (_) => const SecurityLegendSheet(),
                      );
                    },
                    child: const Text('What does this mean?'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SecurityDistributionBar(credentials: credentials),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _sortMode == RecentSortMode.created
                        ? 'Recently Added'
                        : 'Recently Updated',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  RecentToggle(
                    mode: _sortMode,
                    onChanged: (mode) {
                      setState(() => _sortMode = mode);
                    },
                  ),
                ],
              ),
              if (recent.isEmpty) ...[
                const SizedBox(height: 12),
                const Text('No credentials yet')
              ] else
                const SizedBox(height: 12),
              ...recent.take(5).map(
                    (c) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: VaultItemCard(credential: c),
                    ),
                  ),
              const SizedBox(height: 32),
              _SecurityHint(
                total: credentials.length,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SecurityHint extends StatelessWidget {
  final int total;

  const _SecurityHint({
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    String resp = 'Tip: Mark sensitive accounts as High account.';
    if (total == 0) {
      resp = 'Start by adding your first credential.';
    }
    return Text(
      resp,
      textAlign: TextAlign.center,
      style: const TextStyle(fontWeight: FontWeight.w500),
    );
  }
}
