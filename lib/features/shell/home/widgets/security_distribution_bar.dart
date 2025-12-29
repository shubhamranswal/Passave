import 'package:flutter/material.dart';

import '../../vault/models/credential.dart';
import '../../vault/models/security_level.dart';
import '../../vault/vault_list_view.dart';

class SecurityDistributionBar extends StatelessWidget {
  final List<Credential> credentials;

  const SecurityDistributionBar({
    super.key,
    required this.credentials,
  });

  @override
  Widget build(BuildContext context) {
    final total = credentials.length;
    if (total == 0) {
      return _empty(context);
    }

    final low =
        credentials.where((c) => c.securityLevel == SecurityLevel.low).length;
    final medium = credentials
        .where((c) => c.securityLevel == SecurityLevel.medium)
        .length;
    final high =
        credentials.where((c) => c.securityLevel == SecurityLevel.high).length;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          _segment(context, low, total, Colors.green, SecurityLevel.low),
          _segment(context, medium, total, Colors.orange, SecurityLevel.medium),
          _segment(context, high, total, Colors.red, SecurityLevel.high),
        ],
      ),
    );
  }

  Widget _segment(
    BuildContext context,
    int count,
    int total,
    Color color,
    SecurityLevel level,
  ) {
    final fraction = count / total;

    return Expanded(
      flex: (fraction * 1000).round(),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VaultListView(filter: level),
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          height: 14,
          color: color,
        ),
      ),
    );
  }

  Widget _empty(BuildContext context) {
    return Container(
      height: 14,
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
