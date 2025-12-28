export 'password_strength_indicator.dart';
export 'password_strength_service.dart';

enum PasswordStrength {
  veryWeak,
  weak,
  fair,
  strong,
  veryStrong,
}

class PasswordStrengthResult {
  final PasswordStrength strength;
  final int score;

  const PasswordStrengthResult({
    required this.strength,
    required this.score,
  });
}
