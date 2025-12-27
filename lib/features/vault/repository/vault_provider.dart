import '../../../core/crypto/encryption_service.dart';
import '../../../core/crypto/key_derivation_service.dart';
import '../../../core/crypto/vault_key_manager.dart';
import '../../../core/crypto/vault_key_manager_global.dart';
import 'encrypted_vault_repository.dart';
import 'hive_vault_repository.dart';
import 'vault_repository.dart';

final vaultKeyManager = VaultKeyManager();
final keyDerivationService = KeyDerivationService();

final hiveRepo = HiveVaultRepository();
final encryptionService = EncryptionService(vaultKeyManagerGlobal);

late final VaultRepository vaultRepository;

Future<void> initVaultRepository() async {
  await hiveRepo.init();
  vaultRepository = EncryptedVaultRepository(
    hiveRepo,
    encryptionService,
  );
}
