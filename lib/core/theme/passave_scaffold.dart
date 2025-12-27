import 'package:flutter/material.dart';

import '../theme/passave_theme.dart';

class PassaveScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;

  const PassaveScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PassaveTheme.background,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: body,
        ),
      ),
    );
  }
}
