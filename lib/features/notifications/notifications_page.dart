import 'package:flutter/material.dart';

import '../../core/utils/theme/passave_theme.dart';
import '../../core/utils/widgets/passave_scaffold.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final today = [
      const _NotificationItemData(
        icon: Icons.warning_amber_rounded,
        title: 'Weak password detected',
        description: 'Your password for GitHub may be weak.',
      ),
      const _NotificationItemData(
        icon: Icons.timer,
        title: 'Auto-lock enabled',
        description: 'Vault auto-lock is set to 5 minutes.',
      ),
    ];

    final earlier = [
      const _NotificationItemData(
        icon: Icons.security,
        title: 'Vault secured',
        description: 'Your vault is encrypted and stored locally.',
      ),
    ];

    final hasNotifications = today.isNotEmpty || earlier.isNotEmpty;

    return PassaveScaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: hasNotifications
          ? ListView(
              children: [
                if (today.isNotEmpty) ...[
                  const _SectionHeader(title: 'Today'),
                  ...today.map((n) => _NotificationItem(data: n)),
                ],
                if (earlier.isNotEmpty) ...[
                  const _SectionHeader(title: 'Earlier'),
                  ...earlier.map((n) => _NotificationItem(data: n)),
                ],
              ],
            )
          : const _EmptyNotifications(),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }
}

class _NotificationItemData {
  final IconData icon;
  final String title;
  final String description;

  const _NotificationItemData({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _NotificationItem extends StatelessWidget {
  final _NotificationItemData data;

  const _NotificationItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            data.icon,
            color: PassaveTheme.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  data.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Security alerts and updates will appear here.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
