import 'dart:math';

class RecoveryKeyService {
  static const _chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  final _rand = Random.secure();

  String generate() {
    return List.generate(
      24,
      (_) => _chars[_rand.nextInt(_chars.length)],
    ).join();
  }
}

final recoveryKeyService = RecoveryKeyService();
