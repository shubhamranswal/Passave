import 'package:hive/hive.dart';

import '../../../core/crypto/vault_key_manager_global.dart';
import '../../../core/vault/vault_metadata.dart';
import '../models/credential.dart';
import 'vault_repository.dart';

class HiveVaultRepository implements VaultRepository {
  static const _boxName = 'vault_box';

  Future<Box<Map>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<Map>(_boxName);
    }
    return Hive.box<Map>(_boxName);
  }

  @override
  Future<List<Credential>> getAll() async {
    if (!await vaultMetadata.exists()) {
      return [];
    }
    if (!vaultKeyManagerGlobal.isUnlocked) {
      throw Exception('Vault is locked');
    }

    final box = await _getBox();
    return box.values.map(_fromMap).toList();
  }

  @override
  Future<Credential?> getById(String id) async {
    if (!await vaultMetadata.exists()) return null;
    if (!vaultKeyManagerGlobal.isUnlocked) {
      throw Exception('Vault is locked');
    }

    final box = await _getBox();
    final data = box.get(id);
    return data == null ? null : _fromMap(data);
  }

  @override
  Future<void> add(Credential credential) async {
    if (!await vaultMetadata.exists()) {
      throw Exception('Vault does not exist');
    }
    if (!vaultKeyManagerGlobal.isUnlocked) {
      throw Exception('Vault is locked');
    }

    final box = await _getBox();
    await box.put(credential.id, _toMap(credential));
  }

  @override
  Future<void> update(Credential credential) async {
    if (!await vaultMetadata.exists()) {
      throw Exception('Vault does not exist');
    }
    if (!vaultKeyManagerGlobal.isUnlocked) {
      throw Exception('Vault is locked');
    }

    final box = await _getBox();
    await box.put(credential.id, _toMap(credential));
  }

  @override
  Future<void> delete(String id) async {
    if (!await vaultMetadata.exists()) {
      throw Exception('Vault does not exist');
    }
    if (!vaultKeyManagerGlobal.isUnlocked) {
      throw Exception('Vault is locked');
    }

    final box = await _getBox();
    await box.delete(id);
  }

  @override
  Future<void> clear() async {
    if (Hive.isBoxOpen(_boxName)) {
      final box = Hive.box<Map>(_boxName);
      await box.clear();
    }
  }

  // ---------- mapping ----------

  Map<String, dynamic> _toMap(Credential c) {
    return {
      'id': c.id,
      'site': c.site,
      'username': c.username,
      'password': c.password,
      'notes': c.notes,
      'securityLevel': c.securityLevel.name,
      'createdAt': c.createdAt.toIso8601String(),
      'updatedAt': c.updatedAt.toIso8601String(),
    };
  }

  Credential _fromMap(Map data) {
    return Credential(
      id: data['id'],
      site: data['site'],
      username: data['username'],
      password: data['password'],
      notes: data['notes'],
      securityLevel: SecurityLevel.values.firstWhere(
        (e) => e.name == data['securityLevel'],
      ),
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
    );
  }
}
