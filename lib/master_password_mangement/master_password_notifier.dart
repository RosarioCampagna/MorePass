import 'package:flutter/foundation.dart';
import 'master_password_storage.dart';

class MasterPasswordNotifier extends ChangeNotifier {
  final MasterPasswordStorage storage;
  String? masterPassword;

  MasterPasswordNotifier({required this.storage}) {
    loadMasterPassword();
  }

  /// Carica la master password dal secure storage.
  Future<void> loadMasterPassword() async {
    masterPassword = await storage.getMasterPassword();
    notifyListeners();
  }

  /// Salva la master password e aggiorna lo stato.
  Future<void> setMasterPassword(String password) async {
    masterPassword = password;
    await storage.saveMasterPassword(password);
    notifyListeners();
  }

  /// Elimina la master password e aggiorna lo stato.
  Future<void> deleteMasterPassword() async {
    masterPassword = null;
    await storage.deleteMasterPassword();
    notifyListeners();
  }
}
