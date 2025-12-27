import 'package:flutter/material.dart';

import '../../../core/theme/passave_theme.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onGenerate;

  const PasswordField({
    super.key,
    required this.controller,
    this.onGenerate,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscure,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: '••••••••••',
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: PassaveTheme.textSecondary,
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: _obscure ? 'Show password' : 'Hide password',
              icon: Icon(
                _obscure ? Icons.visibility_off : Icons.visibility,
                color: PassaveTheme.textSecondary,
              ),
              onPressed: () {
                setState(() {
                  _obscure = !_obscure;
                });
              },
            ),
            IconButton(
              tooltip: 'Generate password',
              icon: const Icon(
                Icons.auto_fix_high,
                color: PassaveTheme.primary,
              ),
              onPressed: widget.onGenerate ??
                  () {
                    // placeholder: generation logic comes later
                  },
            ),
          ],
        ),
        filled: true,
        fillColor: PassaveTheme.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
