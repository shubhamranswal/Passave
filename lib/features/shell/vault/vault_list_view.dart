import 'package:flutter/material.dart';
import 'package:passave/core/utils/widgets/passave_scaffold.dart';
import 'package:passave/features/shell/vault/repository/vault_provider.dart';
import 'package:passave/features/shell/vault/widgets/vault_search_bar.dart';

import '../../../core/utils/theme/passave_theme.dart';
import 'add_credential_page.dart';
import 'models/credential.dart';
import 'models/security_level.dart';
import 'models/vault_query.dart';
import 'widgets/vault_item_card.dart';

class VaultListView extends StatefulWidget {
  final SecurityLevel? filter;
  const VaultListView({super.key, this.filter});

  @override
  State<VaultListView> createState() => _VaultListViewState();
}

class _VaultListViewState extends State<VaultListView> {
  String _query = '';
  SecurityLevel? _filter;
  VaultSort _sort = VaultSort.recentUpdated;

  @override
  void initState() {
    super.initState();
    _filter = widget.filter;
  }

  List<Credential> _applyFilters(List<Credential> all) {
    final q = _query.toLowerCase();

    var result = all.where((c) {
      final matchesLevel = _filter == null || c.securityLevel == _filter;

      final matchesQuery = q.isEmpty ||
          c.title.toLowerCase().contains(q) ||
          c.username.toLowerCase().contains(q) ||
          (c.notes?.toLowerCase().contains(q) ?? false);

      return matchesLevel && matchesQuery;
    }).toList();

    switch (_sort) {
      case VaultSort.recentCreated:
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case VaultSort.recentUpdated:
        result.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
      case VaultSort.alphabetical:
        result.sort((a, b) => a.title.compareTo(b.title));
        break;
    }

    return result;
  }

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

  InputDecoration dropdownDecoration(BuildContext context) {
    return InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Theme.of(context).dividerColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    List<Widget> buildChips<T>(
      List<T> items,
      T? selected,
      void Function(T?) onSelected,
      bool addSpacing,
    ) {
      return items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;

        Widget chip = ChoiceChip(
          selectedColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.15),
          labelStyle: TextStyle(
            color:
                selected == item ? Theme.of(context).colorScheme.primary : null,
          ),
          label: Text(itemName(item.toString())),
          selected: selected == item,
          onSelected: (_) => onSelected(item),
          side: BorderSide(
            color: selected == item
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade400,
            width: 1.2,
          ),
        );

        if (addSpacing && index != 0) {
          chip = Padding(
            padding: const EdgeInsets.only(left: 6),
            child: chip,
          );
        }

        return chip;
      }).toList();
    }

    final securityChips = buildChips<SecurityLevel?>(
      [null, ...SecurityLevel.values],
      _filter,
      (v) => setState(() => _filter = v),
      isSmallScreen,
    );

    final sortChips = buildChips<VaultSort>(
      VaultSort.values,
      _sort,
      (v) => setState(() => _sort = v!),
      isSmallScreen,
    );

    TextStyle textStyle = const TextStyle(
      fontSize: 12,
      color: Colors.grey,
      fontWeight: FontWeight.w500,
    );

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
              final filtered = _applyFilters(all);
              return all.isEmpty
                  ? const _EmptyVaultView()
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 16, right: 16),
                          child: VaultSearchBar(onChanged: (q) {
                            setState(() => _query = q.toLowerCase());
                          }),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: isSmallScreen ? 5 : 10),
                            child: isSmallScreen
                                ? Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Security Level',
                                            style: textStyle,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                              child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: securityChips,
                                            ),
                                          )),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Sort by',
                                            style: textStyle,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                              child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: sortChips,
                                            ),
                                          )),
                                        ],
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Security Level',
                                              style: textStyle,
                                            ),
                                            const SizedBox(height: 4),
                                            Wrap(
                                                spacing: 5,
                                                children: securityChips),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Sort by',
                                              style: textStyle,
                                            ),
                                            const SizedBox(height: 4),
                                            Wrap(
                                                spacing: 5, children: sortChips)
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                        Expanded(
                            child: ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            if (all.isEmpty)
                              const _EmptyVaultView()
                            else if (filtered.isEmpty)
                              _EmptySearchResultView(query: _query)
                            else
                              ...filtered
                                  .take(filtered.length)
                                  .map((c) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 12),
                                        child: VaultItemCard(
                                            credential: c, query: _query),
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

  String itemName(String item) {
    switch (item) {
      case 'VaultSort.alphabetical':
        return 'Alphabetical';
      case 'VaultSort.recentCreated':
        return 'Recent Created';
      case 'VaultSort.recentUpdated':
        return 'Recent Updated';
      case 'SecurityLevel.low':
        return 'Low';
      case 'SecurityLevel.medium':
        return 'Medium';
      case 'SecurityLevel.high':
        return 'High';
      default:
        return 'All';
    }
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
                text: 'No results found for ',
                style: Theme.of(context).textTheme.titleMedium,
                children: [
                  TextSpan(
                    text: query,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const TextSpan(
                    text: '. Try a different search.',
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
