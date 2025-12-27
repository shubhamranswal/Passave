class VaultSession {
  bool isRecoveryMode = false;

  void enterRecovery() {
    isRecoveryMode = true;
  }

  void exitRecovery() {
    isRecoveryMode = false;
  }
}

final vaultSession = VaultSession();
