import 'package:hive/hive.dart';

import '../models/credential.dart';
import 'vault_repository.dart';

class HiveVaultRepository implements VaultRepository {
  static const _boxName = 'vault_box';
  late Box<Map> _box;

  Future<void> init() async {
    _box = await Hive.openBox<Map>(_boxName);
  }

  @override
  Future<List<Credential>> getAll() async {
    return _box.values.map(_fromMap).toList();
  }

  @override
  Future<Credential?> getById(String id) async {
    final data = _box.get(id);
    if (data == null) return null;
    return _fromMap(data);
  }

  @override
  Future<void> add(Credential credential) async {
    await _box.put(credential.id, _toMap(credential));
  }

  @override
  Future<void> update(Credential credential) async {
    await _box.put(credential.id, _toMap(credential));
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> clear() async {
    await _box.clear();
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
