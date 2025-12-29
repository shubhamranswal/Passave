import 'package:flutter/material.dart';
import 'package:passave/core/crypto/vault/vault_controller.dart';
import 'package:passave/features/account/account_page.dart';
import 'package:passave/features/auth/vault_locked_page.dart';

import '../../core/utils/theme/passave_theme.dart';
import '../../core/utils/widgets/passave_scaffold.dart';
import '../home/home_overview_page.dart';
import '../notifications/notifications_page.dart';
import '../vault/add_credential_page.dart';
import '../vault/vault_list_view.dart';

enum HomeTab {
  vault,
  overview,
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: vaultController,
        builder: (context, _) {
          if (vaultController.isLocked) return const VaultLockedPage();
          return const _UnlockedShell();
        });
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _NavIcon({
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        size: 26,
        color: active ? PassaveTheme.primary : Colors.grey.shade500,
      ),
    );
  }
}

class _UnlockedShell extends StatefulWidget {
  const _UnlockedShell();

  @override
  State<_UnlockedShell> createState() => _UnlockedShellState();
}

class _UnlockedShellState extends State<_UnlockedShell> {
  HomeTab _currentTab = HomeTab.overview;

  @override
  Widget build(BuildContext context) {
    return PassaveScaffold(
      appBar: AppBar(
        title: const Text('Passave'),
        leading: IconButton(
          icon: const CircleAvatar(
            radius: 25,
            child: Icon(
              Icons.account_circle_rounded,
              size: 40,
            ),
          ),
          onPressed: () => _open(const AccountPage()),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => _open(const NotificationsPage()),
          ),
        ],
      ),
      floatingActionButton: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: PassaveTheme.primary.withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipOval(
          child: FloatingActionButton(
            elevation: 0,
            backgroundColor: PassaveTheme.primary,
            onPressed: () => _open(const AddCredentialPage()),
            child: const Icon(Icons.add, size: 32),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _bottomBar(),
      body: _buildBody(),
    );
  }

  Widget _bottomBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      clipBehavior: Clip.antiAlias,
      notchMargin: 10,
      elevation: 12,
      color: Colors.white,
      child: SizedBox(
        height: 72,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavIcon(
                icon: Icons.list,
                active: _currentTab == HomeTab.vault,
                onTap: () => setState(() => _currentTab = HomeTab.vault),
              ),
              _NavIcon(
                icon: Icons.security,
                active: _currentTab == HomeTab.overview,
                onTap: () => setState(() => _currentTab = HomeTab.overview),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return _currentTab == HomeTab.vault
        ? const VaultListView()
        : const HomeOverviewPage();
  }

  void _open(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}
