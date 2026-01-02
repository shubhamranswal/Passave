import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProfile {
  final String? name;
  final String? email;
  final String? phone;
  final String avatarId;
  final DateTime createdAt;

  const UserProfile({
    this.name,
    this.email,
    this.phone,
    required this.avatarId,
    required this.createdAt,
  });
}

class UserProfileService extends ChangeNotifier {
  static const _key = 'user_profile';
  final _storage = const FlutterSecureStorage();

  UserProfile? _cached;

  Future<void> save(UserProfile profile) async {
    _cached = profile;

    await _storage.write(
      key: _key,
      value: jsonEncode({
        'name': profile.name,
        'email': profile.email,
        'phone': profile.phone,
        'avatarId': profile.avatarId,
        'createdAt': profile.createdAt.toIso8601String(),
      }),
    );

    notifyListeners();
  }

  Future<UserProfile?> load() async {
    if (_cached != null) return _cached;

    final raw = await _storage.read(key: _key);
    if (raw == null) return null;

    final json = jsonDecode(raw);
    _cached = UserProfile(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      avatarId: json['avatarId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
    return _cached;
  }

  Future<void> clear() async {
    await _storage.delete(key: _key);
  }

  Future<bool> exists() async {
    return await _storage.containsKey(key: _key);
  }

  UserProfile? get current => _cached;
}

final userProfileService = UserProfileService();
