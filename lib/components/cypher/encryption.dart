import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';
import 'dart:math';
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

    baseKey = '$firstQuarterbaseKey$secondQuarterbaseKey$thirdQuarterbaseKey$lastQuarterbaseKey';

    return baseKey;
  }

  //cifra il testo in input
  String encryptData(String text) {
    //crea la chiave di cifratura
    final encryptionKey = encrypt.Key.fromUtf8(formatKey());

    //crea l'iv
    final iv = encrypt.IV.fromUtf8(encryptionKey.base64.substring(0, 16));

    //crea l'encrypter che va a cifrare il testo
    final encrypter = encrypt.Encrypter(encrypt.AES(encryptionKey, mode: encrypt.AESMode.cbc));

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
    final encrypter = encrypt.Encrypter(encrypt.AES(encryptionKey, mode: encrypt.AESMode.cbc));

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
  /// Genera un salt casuale di [length] byte.
  /// Il salt viene generato usando Random.secure e viene restituito come Uint8List.
  Uint8List generateSalt({int length = 16}) {
    final random = Random.secure();
    final saltBytes = List<int>.generate(length, (_) => random.nextInt(256));
    return Uint8List.fromList(saltBytes);
  }

  Uint8List deriveKeyDirect(String masterPassword, Uint8List salt) {
    final input = masterPassword + base64Encode(salt);
    final hash = crypto.sha512.convert(utf8.encode(input)).bytes;
    return Uint8List.fromList(hash); // 64 byte
  }

  /// Cifra il testo usando direttamente la master password.
  ///
  /// La funzione esegue:
  ///  1. Derivazione della chiave tramite SHA-512 (funzione sincrona)
  ///  2. Divisone dei 64 byte in:
  ///     • 32 byte per AES-CBC
  ///     • 32 byte per HMAC-SHA256
  ///  3. Generazione casuale dell'IV e cifratura del plaintext.
  ///  4. Calcolo dell'HMAC sui byte concatenati (IV + ciphertext).
  String encryptData(String plainText, String masterPassword, Uint8List salt) {
    // Deriva chiave a 64 byte: i primi 32 per AES, gli altri 32 per HMAC.
    final keyBytes = deriveKeyDirect(masterPassword, salt);
    final encryptionKey = encrypt.Key(Uint8List.fromList(keyBytes.sublist(0, 32)));
    final hmacKey = keyBytes.sublist(32, 64);

    // Genera un IV casuale di 16 byte.
    final iv = encrypt.IV.fromSecureRandom(16);

    final encrypter = encrypt.Encrypter(
      encrypt.AES(encryptionKey, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
    );

    final encrypted = encrypter.encrypt(plainText, iv: iv);

    // Calcola l'HMAC sull'unione di IV e ciphertext.
    final hmacData = iv.bytes + encrypted.bytes;
    final hmacDigest = crypto.Hmac(crypto.sha256, hmacKey).convert(hmacData);
    final hmacBase64 = base64Encode(hmacDigest.bytes);

    return "${iv.base64}:${encrypted.base64}:$hmacBase64";
  }

  /// Decifra il testo cifrato usando direttamente la master password.
  ///
  /// La funzione esegue i passaggi inversi:
  ///  1. Deriva la chiave dalla master password (e dal salt) con SHA‑512.
  ///  2. Divide la chiave in AES e HMAC
  ///  3. Verifica l'HMAC e, se valido, decripta il ciphertext.
  String decryptData(String encryptedData, String masterPassword, Uint8List salt) {
    final parts = encryptedData.split(':');
    if (parts.length != 3) {
      throw Exception("Formato del messaggio cifrato non valido.");
    }

    final iv = encrypt.IV.fromBase64(parts[0]);
    final ciphertext = encrypt.Encrypted.fromBase64(parts[1]);
    final providedHmac = parts[2];

    final keyBytes = deriveKeyDirect(masterPassword, salt);
    final encryptionKey = encrypt.Key(Uint8List.fromList(keyBytes.sublist(0, 32)));
    final hmacKey = keyBytes.sublist(32, 64);

    // Ricalcola l'HMAC.
    final hmacData = iv.bytes + ciphertext.bytes;
    final computedHmac = crypto.Hmac(crypto.sha256, hmacKey).convert(hmacData);
    final computedHmacBase64 = base64Encode(computedHmac.bytes);

    if (computedHmacBase64 != providedHmac) {
      throw Exception("Integrità compromessa: HMAC non valido.");
    }

    final encrypter = encrypt.Encrypter(
      encrypt.AES(encryptionKey, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
    );

    return encrypter.decrypt(ciphertext, iv: iv);
  }
}
