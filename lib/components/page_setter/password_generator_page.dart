import 'package:flutter/cupertino.dart';
import 'package:morepass/pages/desktop/password_generator_desktop.dart';
import 'package:morepass/pages/mobile/password_generator.dart';

class PasswordGeneratorPage extends StatelessWidget {
  const PasswordGeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width < 1000
        ? PasswordGenerator()
        : PasswordGeneratorDesktop();
  }
}
