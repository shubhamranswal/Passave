import 'package:flutter/cupertino.dart';

import '../../../../core/crypto/encryption/encryption_service.dart';
import '../models/credential.dart';
import 'vault_repository.dart';

class EncryptedVaultRepository extends ChangeNotifier
    implements VaultRepository {
  final VaultRepository _inner;
  final EncryptionService _crypto;

  EncryptedVaultRepository(this._inner, this._crypto);

  @override
  Future<List<Credential>> getAll() async {
    final encrypted = await _inner.getAll();
    return Future.wait(encrypted.map(_decryptCredential));
  }

  @override
  Future<Credential?> getById(String id) async {
    final encrypted = await _inner.getById(id);
    if (encrypted == null) return null;
    return _decryptCredential(encrypted);
  }

  @override
  Future<void> add(Credential credential) async {
    final encrypted = await _encryptCredential(credential);
    await _inner.add(encrypted);
    notifyListeners();
  }

  @override
  Future<void> update(Credential credential) async {
    final encrypted = await _encryptCredential(credential);
    await _inner.update(encrypted);
    notifyListeners();
  }

  @override
  Future<void> delete(String id) async {
    await _inner.delete(id);
    notifyListeners();
  }

  @override
  Future<void> clear() async {
    await _inner.clear();
    notifyListeners();
  }

  Future<Credential> _encryptCredential(Credential c) async {
    return c.copyWith(
      title: await _crypto.encrypt(c.title),
      site: await _crypto.encrypt(c.site!),
      username: await _crypto.encrypt(c.username),
      password: await _crypto.encrypt(c.password),
      notes: c.notes == null ? null : await _crypto.encrypt(c.notes!),
      updatedAt: c.updatedAt,
    );
  }

  Future<Credential> _decryptCredential(Credential c) async {
    return c.copyWith(
      title: await _crypto.decrypt(c.title),
      site: await _crypto.decrypt(c.site!),
      username: await _crypto.decrypt(c.username),
      password: await _crypto.decrypt(c.password),
      notes: c.notes == null ? null : await _crypto.decrypt(c.notes!),
      updatedAt: c.updatedAt,
    );
  }
}
