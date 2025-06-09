import 'package:flutter/material.dart';
import 'package:morepass/apis/apis.dart';
import 'package:morepass/components/login_register.dart';
import 'package:morepass/components/master_password_dialog.dart';
import 'package:morepass/master_password_mangement/master_password_notifier.dart';
import 'package:morepass/pages/color_theme_choose.dart';
import 'package:morepass/pages/desktop/password_list_desktop.dart';
import 'package:morepass/pages/mobile/homepage.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../colors.dart';

class AUthGate extends StatelessWidget {
  const AUthGate({super.key});

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Salva Dato'),
          content: Text('Vuoi salvare il dato in Secure Storage?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('Salva'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Annulla'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MasterPasswordNotifier>(
        builder: (context, masterPasswordNotifier, child) => StreamBuilder(
            stream: Supabase.instance.client.auth.onAuthStateChange,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(color: primary);
              }

              final session = snapshot.hasData ? snapshot.data!.session : null;

              return session != null
                  ? StreamBuilder(
                      stream: SupaBase().getUser('preferencies'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator(color: primary);
                        }

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          showMasterPaswordDialog(context, masterPasswordNotifier);
                        });

                        final user = snapshot.data!;

                        return user.first
                            ? const ColorThemeChoosePage()
                            : MediaQuery.of(context).size.width < 1000
                                ? const Homepage()
                                : PasswordListDesktop();
                      },
                    )
                  : const LoginRegister();
            }),
      ),
    );
  }
}
