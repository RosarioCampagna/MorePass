import 'package:flutter/material.dart';
import 'package:morepass/apis/apis.dart';

Color orange = const Color.fromARGB(255, 197, 124, 40);
Color red = const Color.fromARGB(255, 197, 40, 40);
Color blue = const Color.fromARGB(255, 40, 56, 197);
Color purple = const Color.fromARGB(255, 100, 40, 197);
Color green = const Color.fromARGB(255, 33, 96, 16);

Color primary = orange;

Future<void> setColor() async {
  switch ((await SupaBase().getColor()).first['color']) {
    case 'green':
      primary = green;
      break;
    case 'red':
      primary = red;
      break;
    case 'blue':
      primary = blue;
      break;
    case 'purple':
      primary = purple;
      break;
    default:
      primary = orange;
  }
}

bool darkMode = true;

Future<void> setDarkMode() async {
  darkMode = (await SupaBase().getDarkMode()).first['dark'];
}

Color secondaryDark = Colors.grey.shade900;
Color secondaryLight = Colors.grey.shade100;

ThemeData theme = ThemeData(scaffoldBackgroundColor: receiveDarkMode(false), primaryColor: primary, useMaterial3: true);

Color receiveDarkMode(bool reverted) {
  return darkMode
      ? reverted
          ? secondaryLight
          : secondaryDark
      : reverted
          ? secondaryDark
          : secondaryLight;
}
