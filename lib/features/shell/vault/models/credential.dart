import 'package:passave/features/shell/vault/models/security_level.dart';

class Credential {
  final String id;
  final String title;
  final String? site;
  final String username;
  final String password;
  final String? notes;
  final SecurityLevel securityLevel;
  final DateTime createdAt;
  final DateTime updatedAt;

  Credential({
    required this.id,
    required this.title,
    required this.site,
    required this.username,
    required this.password,
    this.notes,
    required this.securityLevel,
    required this.createdAt,
    required this.updatedAt,
  });

  Credential copyWith({
    String? title,
    String? site,
    String? username,
    String? password,
    String? notes,
    SecurityLevel? securityLevel,
    DateTime? updatedAt,
  }) {
    return Credential(
      id: id,
      title: title ?? this.title,
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
