import 'package:flutter/material.dart';
import 'package:passave/features/account/account_page.dart';

import '../../core/crypto/vault_key_manager_global.dart';
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
          onPressed: _onSecurityPressed,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: _onNotificationPressed,
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
            onPressed: _onAddPressed,
            child: const Icon(Icons.add, size: 32),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
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
                  onTap: () => _switch(HomeTab.vault),
                ),
                _NavIcon(
                  icon: Icons.security,
                  active: _currentTab == HomeTab.overview,
                  onTap: () => _switch(HomeTab.overview),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return _currentTab == HomeTab.vault
        ? const VaultListView()
        : const HomeOverviewPage();
  }

  void _switch(HomeTab tab) {
    if (!vaultKeyManagerGlobal.isUnlocked) return;
    if (_currentTab == tab) return;
    setState(() => _currentTab = tab);
  }

  void _onPressed(Widget page) {
    if (!vaultKeyManagerGlobal.isUnlocked) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  void _onSecurityPressed() {
    _onPressed(const AccountPage());
  }

  void _onNotificationPressed() {
    _onPressed(const NotificationsPage());
  }

  void _onAddPressed() {
    _onPressed(const AddCredentialPage());
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
