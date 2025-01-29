import 'package:flutter/cupertino.dart';
import 'package:morepass/pages/desktop/settings_desktop.dart';
import 'package:morepass/pages/mobile/settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width < 1000
        ? SettingsPageMobile()
        : SettingsPageDesktop();
  }
}
