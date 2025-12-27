class VaultSession {
  bool isRecoveryMode = false;
  bool _locked = true;

  void enterRecovery() {
    isRecoveryMode = true;
  }

  void exitRecovery() {
    isRecoveryMode = false;
  }

  bool get isLocked => _locked;

  void lock() {
    _locked = true;
  }

  void unlock() {
    _locked = false;
  }
}

final vaultSession = VaultSession();
