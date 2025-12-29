import '../../features/shell/vault/models/credential.dart';
import '../../features/shell/vault/models/security_level.dart';

class VaultScore {
  final int score;
  final String label;

  VaultScore(this.score, this.label);
}

VaultScore calculateVaultScore(List<Credential> credentials) {
  if (credentials.isEmpty) {
    return VaultScore(0, 'Empty vault');
  }

  int high = 0, medium = 0, low = 0;

  for (final c in credentials) {
    switch (c.securityLevel) {
      case SecurityLevel.high:
        high++;
        break;
      case SecurityLevel.medium:
        medium++;
        break;
      case SecurityLevel.low:
        low++;
        break;
    }
  }

  final raw = high * 3 + medium * 2 + low;
  final max = credentials.length * 3;

  final score = ((raw / max) * 100).round().clamp(0, 100);

  final label = score >= 80
      ? 'Well organized'
      : score >= 50
          ? 'Needs attention'
          : 'Poorly organized';

  return VaultScore(score, label);
}
