enum PasswordStrength {
  weak,
  medium,
  strong,
}

class PasswordStrengthResult {
  final PasswordStrength strength;
  final String label;

  const PasswordStrengthResult(this.strength, this.label);
}

class PasswordStrengthAnalyzer {
  static PasswordStrengthResult analyze(String password) {
    if (password.length < 8) {
      return const PasswordStrengthResult(
        PasswordStrength.weak,
        'Too short',
      );
    }

    int score = 0;

    if (password.length >= 12) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

    if (score <= 2) {
      return const PasswordStrengthResult(
        PasswordStrength.weak,
        'Weak',
      );
    }

    if (score <= 4) {
      return const PasswordStrengthResult(
        PasswordStrength.medium,
        'Medium',
      );
    }

    return const PasswordStrengthResult(
      PasswordStrength.strong,
      'Strong',
    );
  }
}
