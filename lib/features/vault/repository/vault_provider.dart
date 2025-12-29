import '../../../core/crypto/encryption/encryption_service.dart';
import '../../../core/crypto/vault_key_manager.dart';
import 'encrypted_vault_repository.dart';
import 'hive_vault_repository.dart';
import 'vault_repository.dart';

final _hiveRepo = HiveVaultRepository();
final _encryptionService = EncryptionService(vaultKeyManagerGlobal);

final VaultRepository vaultRepository = EncryptedVaultRepository(
  _hiveRepo,
  _encryptionService,
);
