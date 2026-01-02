import 'package:flutter/material.dart';
import 'package:passave/core/utils/widgets/credential_logo.dart';

import '../credential_detail_page.dart';
import '../models/credential.dart';

class VaultItemCard extends StatelessWidget {
  final Credential credential;
  final String query;

  const VaultItemCard({
    super.key,
    required this.credential,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CredentialDetailPage(credential: credential),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 44,
              height: 44,
              child: CredentialLogo(
                site: credential.site,
                fallbackText: credential.title,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _IconTextRow(
                    icon: '',
                    child: _HighlightText(
                        text: credential.title,
                        query: query,
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  const SizedBox(height: 4),
                  _IconTextRow(
                    icon: '',
                    child: _HighlightText(
                        text: credential.username,
                        query: query,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  if (credential.notes != null) ...[
                    const SizedBox(height: 4),
                    _IconTextRow(
                        icon: '',
                        child: _HighlightText(
                            text: credential.notes!,
                            query: query,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.bodySmall)),
                  ]
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _HighlightText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle? style;
  final int maxLines;

  const _HighlightText({
    required this.text,
    required this.query,
    required this.style,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final index = query.isEmpty ? -1 : lowerText.indexOf(lowerQuery);

    return Text.rich(
      TextSpan(
        style: style,
        children: index < 0
            ? [TextSpan(text: text)]
            : [
                TextSpan(text: text.substring(0, index)),
                TextSpan(
                  text: text.substring(index, index + query.length),
                  style: style?.copyWith(
                    color: Theme.of(context).colorScheme.surfaceTint,
                  ),
                ),
                TextSpan(text: text.substring(index + query.length)),
              ],
      ),
      softWrap: true,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _IconTextRow extends StatelessWidget {
  final String icon;
  final Widget child;

  const _IconTextRow({
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(icon),
        const SizedBox(width: 8),
        Expanded(child: child),
      ],
    );
  }
}
