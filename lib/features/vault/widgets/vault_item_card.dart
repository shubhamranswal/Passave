import 'package:flutter/material.dart';
import 'package:passave/features/vault/models/credential.dart';

import '../../../core/theme/passave_theme.dart';
import '../credential_detail_page.dart';

class VaultItemCard extends StatelessWidget {
  final Credential credential;

  const VaultItemCard({
    super.key,
    required this.credential,
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
          color: PassaveTheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: PassaveTheme.divider,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.language),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    credential.site,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    credential.username,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: PassaveTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
