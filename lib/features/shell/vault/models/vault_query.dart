import 'security_level.dart';

enum VaultSort {
  recentUpdated,
  recentCreated,
  alphabetical,
}

class VaultQuery {
  final String query;
  final SecurityLevel? securityLevel;
  final VaultSort sort;

  const VaultQuery({
    this.query = '',
    this.securityLevel,
    this.sort = VaultSort.recentUpdated,
  });

  VaultQuery copyWith({
    String? query,
    SecurityLevel? securityLevel,
    VaultSort? sort,
  }) {
    return VaultQuery(
      query: query ?? this.query,
      securityLevel: securityLevel ?? this.securityLevel,
      sort: sort ?? this.sort,
    );
  }
}
