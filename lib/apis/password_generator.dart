import 'dart:math';

import 'package:flutter/material.dart';

//genera una password casuale di lunghezza specificata
//passa le variabili per conoscere la natura della password generata
String generatePassword(int passwordLength, bool excDuplicate, bool includeSym,
    bool includeLow, bool includeUp, bool includeNum) {
  late String tempPassword;
  String randomPass = '';

  //lista di caratteri da tenere in considerazione per la password
  final Map<String, dynamic> characters = {
    'lowerCase': 'abcdefghijklmnopqrstuvwxyz',
    'upperCase': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
    'numbers': '0123456789',
    'symbols': r"!@#\$&*~"
  };

  //fai un join di tutti i caratteri nel map in una sola stringa
  tempPassword = characters.values.join('');

  //se si escludono le lettere minuscole
  if (!includeLow) {
    tempPassword = tempPassword.replaceAll('abcdefghijklmnopqrstuvwxyz', '');
  }

  //se si escludono le lettere maiuscole
  if (!includeUp) {
    tempPassword = tempPassword.replaceAll('ABCDEFGHIJKLMNOPQRSTUVWXYZ', '');
  }

  //se si escludono i simboli
  if (!includeSym) {
    tempPassword = tempPassword.replaceAll(r"!@#\$&*~", '');
  }

  //se si escludono i numeri
  if (!includeNum) {
    tempPassword = tempPassword.replaceAll("0123456789", '');
  }

  //se la lunghezza di della stringa da cui ricavare i caratteri è minore della
  //lunghezza desiderata per la password, imposta una password con duplicati
  if (tempPassword.length < passwordLength) {
    excDuplicate = false;
  }

  //genera la password tramite un ciclo for che arriva da 0 alla lunghezza desiderata
  for (int i = 0; i < passwordLength; i++) {
    //prendi dalla lista di caratteri un carattere randomico
    String randomChar = tempPassword[Random().nextInt(tempPassword.length)];

    //se è impostata l'esclusione dei duplicati
    if (excDuplicate) {
      //se la password contiene quel carattere vai uno step indietro nel ciclo
      //se no aggiungilo alla password finale
      randomPass.contains(randomChar) ? i-- : randomPass += randomChar;
    } else {
      //aggiungilo alla password finale
      randomPass += randomChar;
    }
  }

  //se la password generata non rispetta i requisiti richiama la funzione
  if (!randomPass.meetsPasswordRequirement(
      includeSym, includeLow, includeUp, includeNum)) {
    return generatePassword(passwordLength, excDuplicate, includeSym,
        includeLow, includeUp, includeNum);
  }

  //ritorna la password generata
  return randomPass;
}

//controlla se la password è una password forte
String isStrong(String psw) {
  //se la password rispetta tutti i requisiti con lunghezza superiore a 10 caratteri
  if (psw.meetsPasswordRequirement(true, true, true, true) &&
      psw.length >= 10) {
    return 'Very strong';
  }

  //se la password rispetta tutti i requisiti con lunghezza inferiore a 10 caratteri
  if (psw.meetsPasswordRequirement(true, true, true, true) && psw.length < 10) {
    return 'Strong';
  }

  //se la password rispetta tutti i requisiti tranne 1 con lunghezza superiore a 10 caratteri
  if ((psw.meetsPasswordRequirement(false, true, true, true) ||
          psw.meetsPasswordRequirement(true, true, true, false) ||
          psw.meetsPasswordRequirement(true, true, false, true) ||
          psw.meetsPasswordRequirement(true, false, true, true)) &&
      psw.length >= 10) {
    return 'Medium';
  }

  //se la password rispetta tutti i requisiti tranne 1 con lunghezza inferiore a 10 caratteri
  if ((psw.meetsPasswordRequirement(false, true, true, true) ||
          psw.meetsPasswordRequirement(true, true, true, false) ||
          psw.meetsPasswordRequirement(true, true, false, true) ||
          psw.meetsPasswordRequirement(true, false, true, true)) &&
      psw.length < 10) {
    return 'Weak';
  }

  //in qualsiasi altro caso
  return 'Very weak';
}

//estendi la classe string validator sulla classe Stringa
extension StringValidators on String {
  //controlla se la password risetta i requisiti richiesti
  bool meetsPasswordRequirement(
      bool includeSym, bool includeLow, bool includeUp, bool includeNum) {
    //imosta un pattern iniziale
    String pattern = r'^';

    //se includi le lettere minuscole aggiungile al pattern
    if (includeLow) {
      pattern = '$pattern(?=.*?[a-z])';
    }

    //se includi le lettere maiuscole aggiungile al pattern
    if (includeUp) {
      pattern = '$pattern(?=.*?[A-Z])';
    }

    //se includi i simboli aggiungile al pattern
    if (includeSym) {
      pattern = pattern + r'(?=.*?[!@#\$&*~])';
    }

    //se includi i numeri aggiungile al pattern
    if (includeNum) {
      pattern = '$pattern(?=.*?[0-9])';
    }

    //assegna il pattern ad una cariabile di registro
    RegExp regEx = RegExp(pattern);

    //controlla se c'è un match
    return regEx.hasMatch(this);
  }

  //controlla se include simboli
  bool includesSym() {
    RegExp regEx = RegExp(r'[!@#\$&*~]');
    return regEx.hasMatch(this);
  }

  //controlla se include numeri
  bool includesNum() {
    RegExp regEx = RegExp(r'[0-9]');
    return regEx.hasMatch(this);
  }

  //controlla se include lettere maiuscole
  bool includesUpper() {
    RegExp regEx = RegExp(r'[A-Z]');
    return regEx.hasMatch(this);
  }

  //controlla se include lettere minuscole
  bool includesLower() {
    RegExp regEx = RegExp(r'([a-z])');
    return regEx.hasMatch(this);
  }
}

//imposta il colore in base alla forza della password
Color passwordStrenght(String password) {
  switch (isStrong(password)) {
    case 'Very strong':
      return Colors.green.shade900;
    case 'Strong':
      return Colors.green.shade700;
    case 'Medium':
      return Colors.yellow.shade700;
    case 'Weak':
      return Colors.orange.shade700;
    default:
      return Colors.red.shade700;
  }
}

//imposta la lunghezza del container in base alla forza della password
double containerWidth(String pswStrengt, BuildContext context) {
  switch (pswStrengt) {
    case 'Very strong':
      return MediaQuery.of(context).size.width;
    case 'Strong':
      return MediaQuery.of(context).size.width * 0.6;
    case 'Medium':
      return MediaQuery.of(context).size.width * 0.5;
    case 'Weak':
      return MediaQuery.of(context).size.width * 0.3;
    default:
      return MediaQuery.of(context).size.width * 0.2;
  }
}
