import '../models/credential.dart';

abstract class VaultRepository {
  Future<List<Credential>> getAll();

  Future<Credential?> getById(String id);

  Future<void> add(Credential credential);

  Future<void> update(Credential credential);

  Future<void> delete(String id);

  Future<void> clear();
}
