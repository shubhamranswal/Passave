import 'package:flutter/material.dart';

import '../../core/crypto/vault_key_manager_global.dart';
import '../account/account_page.dart';
import '../auth/vault_locked_page.dart';
import '../home/home_overview_page.dart';
import '../notifications/notifications_page.dart';
import '../vault/add_credential_page.dart';
import '../vault/vault_list_view.dart';

enum MainTab {
  home,
  vault,
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  MainTab _currentTab = MainTab.vault; // TEMP: keep old behavior

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.account_circle),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AccountPage(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationsPage(),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // ADD (disabled for now)
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                iconSize: 32,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddCredentialPage(),
                    ),
                  );
                },
              ),

              // HOME (disabled for now)
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  setState(() => _currentTab = MainTab.home);
                },
              ),

              // VAULT (active)
              IconButton(
                icon: Icon(
                  Icons.lock,
                  color: _currentTab == MainTab.vault
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
                onPressed: _switchToVault,
              ),
            ],
          ),
        ),
      ),
      body: _currentTab == MainTab.home
          ? const HomeOverviewPage()
          : const VaultListView(),
    );
  }

  void _switchToVault() {
    if (!vaultKeyManagerGlobal.isUnlocked) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const VaultLockedPage(),
        ),
      );
      return;
    }

    setState(() => _currentTab = MainTab.vault);
  }
}
