import 'package:passave/core/security/password_strength/password_strength.dart';

class PasswordStrengthService {
  PasswordStrengthResult analyze(String password) {
    final lengthScore = _lengthScore(password);
    final varietyScore = _varietyScore(password);
    final patternPenalty = _patternPenalty(password);

    int score = lengthScore + varietyScore - patternPenalty;
    score = score.clamp(0, 100);

    return PasswordStrengthResult(
      score: score,
      strength: _strengthFromScore(score),
    );
  }

  int _lengthScore(String password) {
    final length = password.length;

    if (length < 6) return 0;
    if (length < 8) return 10;
    if (length < 10) return 20;
    if (length < 14) return 30;
    if (length < 20) return 40;
    return 50;
  }

  int _varietyScore(String password) {
    int score = 0;

    if (RegExp(r'[a-z]').hasMatch(password)) score += 10;
    if (RegExp(r'[A-Z]').hasMatch(password)) score += 10;
    if (RegExp(r'[0-9]').hasMatch(password)) score += 10;
    if (RegExp(r'[^a-zA-Z0-9]').hasMatch(password)) score += 10;

    return score;
  }

  int _patternPenalty(String password) {
    int penalty = 0;

    // all same character
    if (RegExp(r'^(.)\1+$').hasMatch(password)) {
      penalty += 30;
    }

    // sequential characters (abc, 123)
    if (_hasSequential(password)) {
      penalty += 20;
    }

    return penalty;
  }

  bool _hasSequential(String password) {
    for (int i = 0; i < password.length - 2; i++) {
      final a = password.codeUnitAt(i);
      final b = password.codeUnitAt(i + 1);
      final c = password.codeUnitAt(i + 2);

      if (b == a + 1 && c == b + 1) {
        return true;
      }
    }
    return false;
  }

  PasswordStrength _strengthFromScore(int score) {
    if (score < 20) return PasswordStrength.veryWeak;
    if (score < 40) return PasswordStrength.weak;
    if (score < 60) return PasswordStrength.fair;
    if (score < 80) return PasswordStrength.strong;
    return PasswordStrength.veryStrong;
  }
}
