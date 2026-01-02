import 'package:flutter/foundation.dart';
import 'package:passave/core/crypto/key_derivation_service.dart';
import 'package:passave/core/crypto/vault/recovery_key/recovery_key_service.dart';

import '../../security/biometric/biometric_service.dart';
import '../vault_key_cache.dart';
import '../vault_key_manager.dart';
import '../vault_verifier.dart';

enum VaultStatus {
  locked,
  unlocked,
  recovery,
}

class VaultController extends ChangeNotifier {
  final kds = KeyDerivationService();

  VaultStatus _status = VaultStatus.locked;

  VaultStatus get status => _status;
  bool get isLocked => _status == VaultStatus.locked;
  bool get isUnlocked => _status == VaultStatus.unlocked;

  void lock({String? reason}) {
    if (_status == VaultStatus.locked) return;
    debugPrint('Vault locked: $reason');

    vaultKeyManagerGlobal.lock();
    _status = VaultStatus.locked;
    notifyListeners();
  }

  Future<bool> unlockWithPassword(String password) async {
    try {
      final key = await kds.deriveKey(password);
      final valid = await vaultVerifier.verify(key);
      if (!valid) {
        await vaultKeyCache.clear();
        return false;
      }

      await vaultKeyManagerGlobal.unlock(key);
      await vaultKeyCache.store(key);

      _status = VaultStatus.unlocked;
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> unlockWithBiometrics() async {
    try {
      if (!await biometricService.shouldUseBiometrics()) return false;
      final authenticated = await biometricService.authenticate();
      if (!authenticated) return false;

      final cachedKey = await vaultKeyCache.load();
      if (cachedKey == null) return false;

      final valid = await vaultVerifier.verify(cachedKey);
      if (!valid) {
        await vaultKeyCache.clear();
        return false;
      }

      await vaultKeyManagerGlobal.unlock(cachedKey);
      _status = VaultStatus.unlocked;
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> unlockWithRecoveryKey(String recoveryKey) async {
    try {
      final ok = await recoveryKeyService.verify(recoveryKey);
      if (!ok) return false;
      notifyListeners();
      _status = VaultStatus.recovery;
      return true;
    } catch (_) {
      return false;
    }
  }

  void exitRecovery() {
    _status = VaultStatus.unlocked;
    notifyListeners();
  }

  Future<void> onAppResumed() async {
    if (_status == VaultStatus.unlocked) return;
    await Future.delayed(const Duration(milliseconds: 300));
    await unlockWithBiometrics();
  }
}

final vaultController = VaultController();
