enum AutoLockTimeout {
  oneMinute,
  fiveMinutes,
  fifteenMinutes,
  never,
}

extension AutoLockTimeoutX on AutoLockTimeout {
  String get label {
    switch (this) {
      case AutoLockTimeout.oneMinute:
        return '1 minute';
      case AutoLockTimeout.fiveMinutes:
        return '5 minutes';
      case AutoLockTimeout.fifteenMinutes:
        return '15 minutes';
      case AutoLockTimeout.never:
        return 'Never';
    }
  }

  Duration? get duration {
    switch (this) {
      case AutoLockTimeout.oneMinute:
        return const Duration(minutes: 1);
      case AutoLockTimeout.fiveMinutes:
        return const Duration(minutes: 5);
      case AutoLockTimeout.fifteenMinutes:
        return const Duration(minutes: 15);
      case AutoLockTimeout.never:
        return null; // means disabled
    }
  }
}
