import 'package:flutter/material.dart';

class PassaveButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final double? width;
  final double? height;

  const PassaveButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final textColor = isPrimary ? Colors.white : primaryColor;

    final buttonStyle = isPrimary
        ? ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: textColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          )
        : OutlinedButton.styleFrom(
            foregroundColor: textColor,
            side: BorderSide(color: primaryColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          );

    final button = isPrimary
        ? ElevatedButton(
            style: buttonStyle,
            onPressed: onPressed,
            child:
                Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
          )
        : OutlinedButton(
            style: buttonStyle,
            onPressed: onPressed,
            child:
                Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
          );

    if (width != null || height != null) {
      return SizedBox(width: width, height: height, child: button);
    }
    return button;
  }
}
