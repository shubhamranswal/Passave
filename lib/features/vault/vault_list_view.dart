import 'package:flutter/material.dart';
import 'package:passave/features/vault/repository/vault_provider.dart';

import 'add_credential_page.dart';
import 'models/credential.dart';
import 'vault_empty_view.dart';
import 'widgets/vault_item_card.dart';

class VaultListView extends StatefulWidget {
  const VaultListView({super.key});

  @override
  State<VaultListView> createState() => _VaultListViewState();
}

class _VaultListViewState extends State<VaultListView> {
  late Future<List<Credential>> _credentialsFuture;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _credentialsFuture = vaultRepository.getAll();
  }

  Future<void> _addCredential() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddCredentialPage(),
      ),
    );
    setState(_load);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Credential>>(
          future: _credentialsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return const Center(
                child: Text('Failed to load vault'),
              );
            }

            final credentials = snapshot.data!;

            // ✅ EMPTY VAULT HANDLED HERE (correct place)
            if (credentials.isEmpty) {
              return VaultEmptyView(
                onAdd: _addCredential,
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: credentials.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final credential = credentials[index];
                return VaultItemCard(
                  credential: credential,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
