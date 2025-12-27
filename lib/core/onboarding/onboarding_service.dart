import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OnboardingService {
  static const _key = 'onboarding_done';
  final _storage = const FlutterSecureStorage();

  Future<bool> isCompleted() async {
    final value = await _storage.read(key: _key);
    return value == 'true';
  }

  Future<void> markCompleted() async {
    await _storage.write(key: _key, value: 'true');
  }
}

final onboardingService = OnboardingService();
