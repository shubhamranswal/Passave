import 'package:flutter/material.dart';
import 'package:passave/core/utils/widgets/passave_scaffold.dart';
import 'package:passave/features/shell/vault/repository/vault_provider.dart';
import 'package:passave/features/shell/vault/widgets/vault_search_bar.dart';

import '../../../core/utils/theme/passave_theme.dart';
import 'add_credential_page.dart';
import 'models/credential.dart';
import 'models/security_level.dart';
import 'widgets/vault_item_card.dart';

class VaultListView extends StatefulWidget {
  final SecurityLevel? filter;
  const VaultListView({super.key, this.filter});

  @override
  State<VaultListView> createState() => _VaultListViewState();
}

class _VaultListViewState extends State<VaultListView> {
  String _query = '';

  String _titleForFilter(SecurityLevel level) {
    switch (level) {
      case SecurityLevel.high:
        return 'High Security';
      case SecurityLevel.medium:
        return 'Medium Security';
      case SecurityLevel.low:
        return 'Low Security';
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = AnimatedBuilder(
        animation: vaultRepository,
        builder: (_, __) {
          return FutureBuilder<List<Credential>>(
            future: vaultRepository.getAll(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final all = snapshot.data ?? const <Credential>[];
              final q = _query.toLowerCase();

              final filtered = all.where((c) {
                final matchesLevel =
                    widget.filter == null || c.securityLevel == widget.filter;

                final matchesQuery = q.isEmpty ||
                    c.site.toLowerCase().contains(q) ||
                    c.username.toLowerCase().contains(q) ||
                    (c.notes?.toLowerCase().contains(q) ?? false);

                return matchesLevel && matchesQuery;
              }).toList();

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: VaultSearchBar(onChanged: (q) {
                      setState(() => _query = q.toLowerCase());
                    }),
                  ),
                  Expanded(
                      child: ListView(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    children: [
                      if (all.isEmpty)
                        const _EmptyVaultView()
                      else if (filtered.isEmpty)
                        _EmptySearchResultView(query: _query)
                      else
                        ...filtered.take(filtered.length).map((c) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child:
                                  VaultItemCard(credential: c, query: _query),
                            )),
                      const SizedBox(height: 40),
                    ],
                  )),
                ],
              );
            },
          );
        });

    if (widget.filter == null) {
      return content;
    }
    return PassaveScaffold(
      appBar: AppBar(
        title: Text(_titleForFilter(widget.filter!)),
      ),
      body: content,
    );
  }
}

class _EmptyVaultView extends StatelessWidget {
  const _EmptyVaultView();

  @override
  Widget build(BuildContext context) {
    return PassaveScaffold(
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
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  Icons.vpn_key_off,
                  size: 36,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddCredentialPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, color: PassaveTheme.surfaceLight),
                  label: const Text(
                    'Get started',
                    style: TextStyle(
                      fontSize: 16,
                      color: PassaveTheme.surfaceLight,
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

class _EmptySearchResultView extends StatelessWidget {
  final String query;

  const _EmptySearchResultView({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.vpn_key_off,
                size: 36,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text.rich(
              TextSpan(
                text: 'No results found for ', // normal text
                style: Theme.of(context).textTheme.titleMedium,
                children: [
                  TextSpan(
                    text: query, // query text
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const TextSpan(
                    text: '. Try a different search.', // normal text again
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Maybe you are yet to add it!',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
