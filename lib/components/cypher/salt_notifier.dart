import 'package:flutter/foundation.dart';
import 'package:morepass/apis/apis.dart';

class SaltNotifier extends ChangeNotifier {
  Uint8List? salt;

  SaltNotifier() {
    loadSalt();
  }

  /// Recupera il salt dal database e aggiorna lo stato.
  Future<void> loadSalt() async {
    try {
      salt = await SupaBase().getSalt();
    } catch (e) {
      debugPrint("Errore nel caricamento del salt: $e");
    }
    notifyListeners();
  }
}
