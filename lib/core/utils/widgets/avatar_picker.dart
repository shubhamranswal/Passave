import 'package:flutter/material.dart';

import '../../user/avatar_registry.dart';

class AvatarPicker extends StatelessWidget {
  final String selectedAvatarId;
  final ValueChanged<String> onSelected;

  const AvatarPicker({
    super.key,
    required this.selectedAvatarId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final avatarEntries = AvatarRegistry.avatars.entries.toList();
    final primaryColor = Theme.of(context).colorScheme.primary;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 100,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: avatarEntries.length,
      itemBuilder: (context, index) {
        final entry = avatarEntries[index];
        final isSelected = entry.key == selectedAvatarId;

        return GestureDetector(
          onTap: () => onSelected(entry.key),
          child: AnimatedScale(
            scale: isSelected ? 1.2 : 1.0, // slightly bigger when selected
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  width: 2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.4),
                          spreadRadius: 4,
                          blurRadius: 12,
                        ),
                      ]
                    : [],
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage(entry.value),
              ),
            ),
          ),
        );
      },
    );
  }
}
