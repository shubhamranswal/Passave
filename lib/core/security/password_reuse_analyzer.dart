import '../../features/vault/models/credential.dart';

class PasswordReuseAnalyzer {
  static Map<String, int> reuseCount(List<Credential> credentials) {
    final map = <String, int>{};

    for (final c in credentials) {
      map[c.password] = (map[c.password] ?? 0) + 1;
    }

    return map;
  }

  static int reusedPasswordsCount(List<Credential> credentials) {
    final reuseMap = reuseCount(credentials);
    return reuseMap.values.where((count) => count > 1).length;
  }
}
