import 'package:morepass/master_password_mangement/secure_storage_service.dart';
import 'storage_service.dart';

class MasterPasswordStorage {
  final SecureStorageService storageService = getStorageService();
  static const String _masterPasswordKey = 'MASTER_PASSWORD';

  Future<void> saveMasterPassword(String masterPassword) async {
    await storageService.write(_masterPasswordKey, masterPassword);
  }

  Future<String?> getMasterPassword() async {
    return await storageService.read(_masterPasswordKey);
  }

  Future<void> deleteMasterPassword() async {
    await storageService.delete(_masterPasswordKey);
  }
}

// Implementa getStorageService():
SecureStorageService getStorageService() {
  // Poiché con le importazioni condizionali il file importato è già quello corretto,
  // puoi semplicemente istanziare l'implementazione.
  // Ad esempio, se stai usando le export condizionali, potresti avere:
  return createStorageService();
}
