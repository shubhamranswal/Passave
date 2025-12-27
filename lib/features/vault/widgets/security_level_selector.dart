import 'package:flutter/material.dart';

import '../../../core/theme/passave_theme.dart';
import '../models/credential.dart';

class SecurityLevelSelector extends StatelessWidget {
  final SecurityLevel initialValue;
  final ValueChanged<SecurityLevel> onChanged;

  const SecurityLevelSelector({
    super.key,
    required this.onChanged,
    this.initialValue = SecurityLevel.medium,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: SecurityLevel.values.map((level) {
        final bool isSelected = level == initialValue;

        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => onChanged(level),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? PassaveTheme.primary : PassaveTheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      isSelected ? PassaveTheme.primary : PassaveTheme.divider,
                ),
              ),
              child: Text(
                _labelFor(level),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : PassaveTheme.textSecondary,
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
