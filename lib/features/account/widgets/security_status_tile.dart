import 'package:flutter/material.dart';
import 'package:passave/core/utils/theme/passave_theme.dart';

class SecurityStatusTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String status;
  final bool ok;
  final VoidCallback? onTap;

  const SecurityStatusTile({
    super.key,
    required this.icon,
    required this.title,
    required this.status,
    required this.ok,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = ok ? PassaveTheme.primary : PassaveTheme.danger;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    status,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}
