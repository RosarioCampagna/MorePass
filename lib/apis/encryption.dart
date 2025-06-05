import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';
import 'dart:math';
import 'package:argon2/argon2.dart';
import 'dart:typed_data';
import 'package:crypto/crypto.dart' as crypto;

class Encryption {
  //prepara la stringa per generare la chiave
  String formatKey() {
    String baseKey = Supabase.instance.client.auth.currentUser!.id;
    baseKey = baseKey.replaceAll('-', '');
    String firstQuarterbaseKey = baseKey.substring(0, 8).toUpperCase();
    String secondQuarterbaseKey = baseKey.substring(8, 16);
    String thirdQuarterbaseKey = baseKey.substring(16, 24).toUpperCase();
    String lastQuarterbaseKey = baseKey.substring(24, 32);

    baseKey =
        '$firstQuarterbaseKey$secondQuarterbaseKey$thirdQuarterbaseKey$lastQuarterbaseKey';

    return baseKey;
  }

  //cifra il testo in input
  String encryptData(String text) {
    //crea la chiave di cifratura
    final encryptionKey = encrypt.Key.fromUtf8(formatKey());

    //crea l'iv
    final iv = encrypt.IV.fromUtf8(encryptionKey.base64.substring(0, 16));

    //crea l'encrypter che va a cifrare il testo
    final encrypter = encrypt.Encrypter(
        encrypt.AES(encryptionKey, mode: encrypt.AESMode.cbc));

    //cifra il testo
    final encrypted = encrypter.encrypt(text, iv: iv);

    //ottieni in ritorno il testo cifrato in base leggibile
    return encrypted.base64;
  }

  //decifra il testo in input
  String decryptData(String encryptedText) {
    //crea la chiave di decifratura
    final encryptionKey = encrypt.Key.fromUtf8(formatKey());

    //crea l'iv
    final iv = encrypt.IV.fromUtf8(encryptionKey.base64.substring(0, 16));

    //crea l'encrypter che va a decifrar il testo
    final encrypter = encrypt.Encrypter(
        encrypt.AES(encryptionKey, mode: encrypt.AESMode.cbc));

    //crea il testo cifrato da base leggibile
    final encrypted = encrypt.Encrypted.fromBase64(encryptedText);

    //decifra il testo
    final decrypted = encrypter.decrypt(encrypted, iv: iv);

    //ottieni in ritorno il testo decifrato
    return decrypted;
  }
}

/* INTEGRAZIONE MIGLIORATA */

class EncryptionHelper {
  // Utilizziamo 64 byte derivati tramite Argon2.
  // I primi 32 per AES-256; i successivi 32 per l'HMAC.
  static const int derivedKeyLength = 64;

  /// Genera un salt casuale di [length] byte e lo restituisce in Base64.
  String generateSalt({int length = 16}) {
    final random = Random.secure();
    final saltBytes = List<int>.generate(length, (_) => random.nextInt(256));
    return base64UrlEncode(saltBytes);
  }

  /// Deriva una chiave di 64 byte utilizzando Argon2Iid a partire da [masterPassword] e [salt].
  Uint8List deriveKey(String masterPassword, String salt) {
    final Uint8List passwordBytes =
        Uint8List.fromList(utf8.encode(masterPassword));
    final Uint8List saltBytes = Uint8List.fromList(utf8.encode(salt));

    final parameters = Argon2Parameters(
      Argon2Parameters.ARGON2_id,
      saltBytes,
      iterations: 3, // Aumenta questo valore per maggiore sicurezza
      memory: 65536, // Memoria in KiB (circa 64 MB)
      lanes: 4, // Grado di parallelismo
    );

    final argon2 = Argon2BytesGenerator();
    argon2.init(parameters);

    final output = Uint8List(derivedKeyLength);
    argon2.generateBytes(passwordBytes, output);
    return output;
  }

  /// Cifra [plainText] usando AES-CBC con PKCS7 padding.
  /// Le chiavi sono derivate con Argon2 a partire da [masterPassword] e [salt]:
  /// - I primi 32 byte sono la chiave di cifratura (AES-256).
  /// - I successivi 32 byte sono la chiave per l'HMAC.
  /// Viene generato un IV casuale; il messaggio finale ha formato:
  /// "iv:ciphertext:hmac", dove ciascuna parte è codificata in Base64.
  String encryptData(String plainText, String masterPassword, String salt) {
    final keyBytes = deriveKey(masterPassword, salt);
    final encryptionKey = encrypt.Key(keyBytes.sublist(0, 32));
    final hmacKey = keyBytes.sublist(32, 64);

    // Genera un IV casuale di 16 byte.
    final iv = encrypt.IV.fromSecureRandom(16);

    final encrypter = encrypt.Encrypter(
      encrypt.AES(encryptionKey, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
    );

    final encrypted = encrypter.encrypt(plainText, iv: iv);

    // Calcola l'HMAC sul concatenato di IV e ciphertext.
    final hmacData = iv.bytes + encrypted.bytes;
    final hmac = crypto.Hmac(crypto.sha256, hmacKey);
    final hmacDigest = hmac.convert(hmacData);
    final hmacBase64 = base64Encode(hmacDigest.bytes);

    // Combina iv, ciphertext e hmac separati da ':'.
    final combined = '${iv.base64}:${encrypted.base64}:$hmacBase64';
    return combined;
  }

  /// Decifra [encryptedData] (formato "iv:ciphertext:hmac").
  /// Verifica l'HMAC e, se valido, decifra restituendo il testo in chiaro.
  String decryptData(String encryptedData, String masterPassword, String salt) {
    final parts = encryptedData.split(':');
    if (parts.length != 3) {
      throw Exception('Formato del messaggio cifrato non valido');
    }

    final ivBase64 = parts[0];
    final ciphertextBase64 = parts[1];
    final providedHmac = parts[2];

    final keyBytes = deriveKey(masterPassword, salt);
    final encryptionKey = encrypt.Key(keyBytes.sublist(0, 32));
    final hmacKey = keyBytes.sublist(32, 64);

    final iv = encrypt.IV.fromBase64(ivBase64);
    final ciphertext = encrypt.Encrypted.fromBase64(ciphertextBase64);

    // Ricalcola l'HMAC.
    final hmacData = iv.bytes + ciphertext.bytes;
    final hmac = crypto.Hmac(crypto.sha256, hmacKey);
    final computedHmacDigest = hmac.convert(hmacData);
    final computedHmacBase64 = base64Encode(computedHmacDigest.bytes);

    if (computedHmacBase64 != providedHmac) {
      throw Exception('Integrità del messaggio compromessa: HMAC non valido.');
    }

    final encrypter = encrypt.Encrypter(
      encrypt.AES(encryptionKey, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
    );

    final decrypted = encrypter.decrypt(ciphertext, iv: iv);
    return decrypted;
  }
}
