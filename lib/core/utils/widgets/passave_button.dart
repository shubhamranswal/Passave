import 'package:flutter/material.dart';

class PassaveButton extends StatelessWidget {
  final String text;
  final Future<void> Function()? onPressed;
  final bool isPrimary;
  final bool loading;
  final bool enabled;
  final double? width;
  final double? height;

  const PassaveButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.loading = false,
    this.enabled = true,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final disabled = loading || !enabled;

    final buttonStyle = isPrimary
        ? ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            disabledBackgroundColor: primaryColor.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          )
        : OutlinedButton.styleFrom(
            foregroundColor: primaryColor,
            disabledForegroundColor: primaryColor.withOpacity(0.5),
            side: BorderSide(color: primaryColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          );

    final child = loading
        ? const SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        : Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w600),
          );

    final button = isPrimary
        ? ElevatedButton(
            style: buttonStyle,
            onPressed: disabled ? null : onPressed,
            child: child,
          )
        : OutlinedButton(
            style: buttonStyle,
            onPressed: disabled ? null : onPressed,
            child: child,
          );

    if (width != null || height != null) {
      return SizedBox(width: width, height: height, child: button);
    }
    return button;
  }
}
