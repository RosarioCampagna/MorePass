import 'package:flutter/material.dart';
import 'package:myapp/apis/apis.dart';
import 'package:myapp/components/login_register.dart';
import 'package:myapp/pages/color_theme_choose.dart';
import 'package:myapp/pages/password_list.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AUthGate extends StatelessWidget {
  const AUthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: Supabase.instance.client.auth.onAuthStateChange,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            final session = snapshot.hasData ? snapshot.data!.session : null;

            return session != null
                ? StreamBuilder(
                    stream: SupaBase().getUser('preferencies'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      final user = snapshot.data!.firstWhere((value) =>
                          value.uid ==
                          Supabase.instance.client.auth.currentUser!.id);

                      return user.first
                          ? const ColorThemeChoosePage()
                          : const PasswordList();
                    })
                : const LoginRegister();
          }),
    );
  }
}
