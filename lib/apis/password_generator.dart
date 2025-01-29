import 'dart:math';

import 'package:flutter/material.dart';

String generatePassword(int passwordLength, bool excDuplicate, bool includeSym,
    bool includeLow, bool includeUp, bool includeNum) {
  late String tempPassword;
  String randomPass = '';
  final Map<String, dynamic> characters = {
    'lowerCase': 'abcdefghijklmnopqrstuvwxyz',
    'upperCase': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
    'numbers': '0123456789',
    'symbols': r"!@#\$&*~"
  };

  tempPassword = characters.values.join('');

  if (!includeLow) {
    tempPassword = tempPassword.replaceAll('abcdefghijklmnopqrstuvwxyz', '');
  }
  if (!includeUp) {
    tempPassword = tempPassword.replaceAll('ABCDEFGHIJKLMNOPQRSTUVWXYZ', '');
  }
  if (!includeSym) {
    tempPassword = tempPassword.replaceAll(r"!@#\$&*~", '');
  }
  if (!includeNum) {
    tempPassword = tempPassword.replaceAll("0123456789", '');
  }
  if (tempPassword.length < passwordLength) {
    excDuplicate = false;
  }

  for (int i = 0; i < passwordLength; i++) {
    String randomChar = tempPassword[Random().nextInt(tempPassword.length)];
    if (excDuplicate) {
      randomPass.contains(randomChar) ? i-- : randomPass += randomChar;
    } else {
      randomPass += randomChar;
    }
  }

  if (!randomPass.meetsPasswordRequirement(
      includeSym, includeLow, includeUp, includeNum)) {
    return generatePassword(passwordLength, excDuplicate, includeSym,
        includeLow, includeUp, includeNum);
  }

  return randomPass;
}

String isStrong(String psw) {
  if (psw.meetsPasswordRequirement(true, true, true, true) &&
      psw.length >= 10) {
    return 'Very strong';
  }

  if (psw.meetsPasswordRequirement(true, true, true, true) && psw.length < 10) {
    return 'Strong';
  }

  if ((psw.meetsPasswordRequirement(false, true, true, true) ||
          psw.meetsPasswordRequirement(true, true, true, false) ||
          psw.meetsPasswordRequirement(true, true, false, true) ||
          psw.meetsPasswordRequirement(true, false, true, true)) &&
      psw.length >= 10) {
    return 'Medium';
  }

  if ((psw.meetsPasswordRequirement(false, true, true, true) ||
          psw.meetsPasswordRequirement(true, true, true, false) ||
          psw.meetsPasswordRequirement(true, true, false, true) ||
          psw.meetsPasswordRequirement(true, false, true, true)) &&
      psw.length < 10) {
    return 'Weak';
  }

  return 'Very weak';
}

extension StringValidators on String {
  bool meetsPasswordRequirement(
      bool includeSym, bool includeLow, bool includeUp, bool includeNum) {
    String pattern = r'^';

    if (includeLow) {
      pattern = '$pattern(?=.*?[a-z])';
    }

    if (includeUp) {
      pattern = '$pattern(?=.*?[A-Z])';
    }

    if (includeSym) {
      pattern = pattern + r'(?=.*?[!@#\$&*~])';
    }

    if (includeNum) {
      pattern = '$pattern(?=.*?[0-9])';
    }

    RegExp regEx = RegExp(pattern);

    return regEx.hasMatch(this);
  }

  bool includesSym() {
    RegExp regEx = RegExp(r'[!@#\$&*~]');
    return regEx.hasMatch(this);
  }

  bool includesNum() {
    RegExp regEx = RegExp(r'[0-9]');
    return regEx.hasMatch(this);
  }

  bool includesUpper() {
    RegExp regEx = RegExp(r'[A-Z]');
    return regEx.hasMatch(this);
  }

  bool includesLower() {
    RegExp regEx = RegExp(r'([a-z])');
    return regEx.hasMatch(this);
  }
}

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
