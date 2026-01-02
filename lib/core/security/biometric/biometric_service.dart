import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final _auth = LocalAuthentication();
  final _storage = const FlutterSecureStorage();
  static const _enabledKey = 'biometric_enabled';

  Future<bool> isAvailable() async {
    return await _auth.canCheckBiometrics && await _auth.isDeviceSupported();
  }

  Future<void> disable() async {
    await _storage.write(key: _enabledKey, value: 'false');
  }

  Future<void> enable() async {
    await _storage.write(key: _enabledKey, value: 'true');
  }

  Future<bool> isEnabled() async {
    return await _storage.read(key: _enabledKey) == 'true';
  }

  Future<bool> shouldUseBiometrics() async {
    final enabled = await isEnabled();
    if (!enabled) return false;
    return isAvailable();
  }

  Future<bool> authenticate() async {
    return await _auth.authenticate(
      localizedReason: 'Unlock your Passave vault',
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    );
  }
}

final biometricService = BiometricService();
