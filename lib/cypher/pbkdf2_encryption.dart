import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

class PBKDF2Encryption {
  /// Deriva una chiave a partire da [masterPassword] e [salt] utilizzando PBKDF2 con SHA256.
  /// - [iterations]: Numero di iterazioni (e.g. 100000).
  /// - [keyLength]: Lunghezza della chiave derivata in byte (e.g. 64).
  Uint8List deriveKey(String masterPassword, Uint8List salt,
      {int iterations = 100000, int keyLength = 64}) {
    final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
    final params = Pbkdf2Parameters(salt, iterations, keyLength);
    pbkdf2.init(params);

    final passwordBytes = Uint8List.fromList(utf8.encode(masterPassword));
    return pbkdf2.process(passwordBytes);
  }
}