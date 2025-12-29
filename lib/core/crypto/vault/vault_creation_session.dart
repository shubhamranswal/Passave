import 'package:cryptography/cryptography.dart';

class VaultCreationSession {
  SecretKey? vaultKey;
  String? recoveryKey;

  bool get isActive => vaultKey != null && recoveryKey != null;

  void start({
    required SecretKey key,
    required String recoveryKey,
  }) {
    vaultKey = key;
    this.recoveryKey = recoveryKey;
  }

  void clear() {
    vaultKey = null;
    recoveryKey = null;
  }
}

final vaultCreationSession = VaultCreationSession();
