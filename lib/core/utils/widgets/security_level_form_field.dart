import 'package:flutter/material.dart';

import '../../../features/shell/vault/models/security_level.dart';

class SecurityLevelFormField extends FormField<SecurityLevel?> {
  SecurityLevelFormField({
    super.key,
    super.initialValue,
    super.validator,
    required ValueChanged<SecurityLevel> onChanged,
  }) : super(
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SecurityLevelSelector(
                  value: state.value,
                  onChanged: (level) {
                    state.didChange(level);
                    onChanged(level);
                  },
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      state.errorText!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
}

class _SecurityLevelSelector extends StatelessWidget {
  final SecurityLevel? value;
  final ValueChanged<SecurityLevel> onChanged;

  const _SecurityLevelSelector({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: SecurityLevel.values.map((level) {
        final bool isSelected = value == level;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => onChanged(level),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).dividerColor,
                ),
              ),
              child: Text(
                _labelFor(level),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _labelFor(SecurityLevel level) {
    switch (level) {
      case SecurityLevel.low:
        return 'Low';
      case SecurityLevel.medium:
        return 'Medium';
      case SecurityLevel.high:
        return 'High';
    }
  }
}
