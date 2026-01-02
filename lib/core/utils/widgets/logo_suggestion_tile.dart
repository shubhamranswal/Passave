import 'package:flutter/material.dart';
import 'package:passave/core/logo_suggestion/logo_suggestion.dart';
import 'package:passave/core/utils/widgets/credential_logo.dart';

class NameSuggestionTile extends StatelessWidget {
  final LogoSuggestion service;
  final VoidCallback onTap;

  const NameSuggestionTile({
    super.key,
    required this.service,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CredentialLogo(
        site: service.site,
        fallbackText: service.name,
      ),
      title: Text(service.name),
      onTap: onTap,
    );
  }
}
