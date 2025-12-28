import 'package:flutter/material.dart';

enum RecentSortMode { created, updated }

class RecentToggle extends StatelessWidget {
  final RecentSortMode mode;
  final ValueChanged<RecentSortMode> onChanged;

  const RecentToggle({
    super.key,
    required this.mode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _chip(
            context,
            label: 'Added',
            selected: mode == RecentSortMode.created,
            onTap: () => onChanged(RecentSortMode.created),
          ),
          _chip(
            context,
            label: 'Updated',
            selected: mode == RecentSortMode.updated,
            onTap: () => onChanged(RecentSortMode.updated),
          ),
        ],
      ),
    );
  }

  Widget _chip(
    BuildContext context, {
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: selected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ),
    );
  }
}
