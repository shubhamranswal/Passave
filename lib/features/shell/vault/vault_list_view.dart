import 'package:flutter/material.dart';
import 'package:passave/core/utils/widgets/passave_scaffold.dart';
import 'package:passave/features/shell/vault/repository/vault_provider.dart';

import 'add_credential_page.dart';
import 'models/credential.dart';
import 'models/security_level.dart';
import 'vault_empty_view.dart';
import 'widgets/vault_item_card.dart';

class VaultListView extends StatefulWidget {
  final SecurityLevel? filter;
  const VaultListView({super.key, this.filter});

  @override
  State<VaultListView> createState() => _VaultListViewState();
}

class _VaultListViewState extends State<VaultListView> {
  @override
  Widget build(BuildContext context) {
    return PassaveScaffold(
      body: AnimatedBuilder(
          animation: vaultRepository,
          builder: (_, __) {
            return FutureBuilder<List<Credential>>(
              future: vaultRepository.getAll(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final all = snapshot.data ?? const <Credential>[];
                final credentials = widget.filter == null
                    ? all
                    : all
                        .where((c) => c.securityLevel == widget.filter)
                        .toList();

                if (credentials.isEmpty) {
                  return VaultEmptyView(
                    onAdd: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddCredentialPage(),
                        ),
                      );
                    },
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: credentials.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return VaultItemCard(
                      credential: credentials[index],
                    );
                  },
                );
              },
            );
          }),
    );
  }
}
