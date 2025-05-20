import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

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

/* class Encryption2 {
  // Prepara l'UID come chiave sicura
  String formatKey() {
    String uid = Supabase.instance.client.auth.currentUser!.id;
    var bytes = utf8.encode(uid);
    var digest = sha256.convert(bytes);
    return digest.toString().substring(0, 32); // Assicura una chiave AES valida
  }

  // Cifra il testo in input
  Map<String, String> encryptData(String text) {
    final encryptionKey = encrypt.Key.fromUtf8(formatKey());
    final iv = encrypt.IV.fromLength(16); // IV casuale

    final encrypter = encrypt.Encrypter(
        encrypt.AES(encryptionKey, mode: encrypt.AESMode.cbc));

    final encrypted = encrypter.encrypt(text, iv: iv);

    return {
      "encryptedData": encrypted.base64,
      "iv": iv.base64 // Salva IV separatamente
    };
  }

  // Decifra il testo in input
  String decryptData(String encryptedText, String ivBase64) {
    final encryptionKey = encrypt.Key.fromUtf8(formatKey());
    final iv = encrypt.IV.fromBase64(ivBase64); // Usa IV salvato

    final encrypter = encrypt.Encrypter(
        encrypt.AES(encryptionKey, mode: encrypt.AESMode.cbc));

    final encrypted = encrypt.Encrypted.fromBase64(encryptedText);

    return encrypter.decrypt(encrypted, iv: iv);
  }
} */