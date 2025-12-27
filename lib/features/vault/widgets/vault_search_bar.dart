import 'package:flutter/material.dart';

import '../../../core/theme/passave_theme.dart';

class VaultSearchBar extends StatelessWidget {
  const VaultSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: PassaveTheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Search passwords',
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
