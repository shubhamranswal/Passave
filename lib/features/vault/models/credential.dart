enum SecurityLevel {
  low,
  medium,
  high,
}

class Credential {
  final String id;
  final String site;
  final String username;
  final String password;
  final String? notes;
  final SecurityLevel securityLevel;
  final DateTime createdAt;
  final DateTime updatedAt;

  Credential({
    required this.id,
    required this.site,
    required this.username,
    required this.password,
    this.notes,
    required this.securityLevel,
    required this.createdAt,
    required this.updatedAt,
  });

  Credential copyWith({
    String? site,
    String? username,
    String? password,
    String? notes,
    SecurityLevel? securityLevel,
    DateTime? updatedAt,
  }) {
    return Credential(
      id: id,
      site: site ?? this.site,
      username: username ?? this.username,
      password: password ?? this.password,
      notes: notes ?? this.notes,
      securityLevel: securityLevel ?? this.securityLevel,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
