import 'package:flutter/material.dart';

class CredentialLogo extends StatelessWidget {
  final String? site;
  final double size;
  final double borderRadius;
  final String fallbackText;

  const CredentialLogo({
    super.key,
    required this.site,
    required this.fallbackText,
    this.size = 40,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    if (site == null || site!.isEmpty) {
      return _FallbackAvatar(
        label: fallbackText,
        size: size,
        borderRadius: borderRadius,
      );
    }

    final faviconUrl = 'https://www.google.com/s2/favicons?sz=64&domain=$site';

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        faviconUrl,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) {
          return _FallbackAvatar(
            label: fallbackText,
            size: size,
            borderRadius: borderRadius,
          );
        },
      ),
    );
  }
}

class _FallbackAvatar extends StatelessWidget {
  final String label;
  final double size;
  final double borderRadius;

  const _FallbackAvatar({
    required this.label,
    required this.size,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final letter = label.isNotEmpty ? label.trim()[0].toUpperCase() : '?';

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _colorFromString(label),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        letter,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.45,
        ),
      ),
    );
  }

  Color _colorFromString(String input) {
    final hash = input.codeUnits.fold(0, (a, b) => a + b);
    const colors = Colors.primaries;
    return colors[hash % colors.length];
  }
}
