import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MasterPasswordStorage {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static const String _masterPasswordKey = 'MASTER_PASSWORD';

  /// Salva la master password nel secure storage.
  Future<void> saveMasterPassword(String masterPassword) async {
    await _secureStorage.write(key: _masterPasswordKey, value: masterPassword);
  }

  /// Recupera la master password, o null se non esiste.
  Future<String?> getMasterPassword() async {
    return await _secureStorage.read(key: _masterPasswordKey);
  }

  /// Elimina la master password dal secure storage.
  Future<void> deleteMasterPassword() async {
    await _secureStorage.delete(key: _masterPasswordKey);
  }
}
