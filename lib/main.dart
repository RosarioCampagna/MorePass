import 'package:flutter/material.dart';
import 'package:morepass/components/app_scroll_behavior.dart';
import 'package:morepass/components/page_setter/auth_gate.dart';
import 'package:morepass/components/colors.dart';
import 'package:morepass/components/cypher/salt_notifier.dart';
import 'package:morepass/master_password_mangement/master_password_notifier.dart';
import 'package:morepass/master_password_mangement/master_password_storage.dart';
import 'package:morepass/pages/color_theme_choose.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const String apiKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  const String dbLink = String.fromEnvironment('SUPABASE_DB_LINK');

  //await dotenv.load();
  //Supabase initilization
  await Supabase.initialize(url: dbLink, anonKey: apiKey);

  // 🔹 Verifica login utente + gestione errori
  if (Supabase.instance.client.auth.currentSession != null) {
    await setColor();
    await setDarkMode();
  }

  runApp(
    MultiProvider(
      providers: [
        // Provider per la master password (già esistente)
        ChangeNotifierProvider(
          create: (_) => MasterPasswordNotifier(storage: MasterPasswordStorage()),
        ),
        // Provider per il salt
        ChangeNotifierProvider(
          create: (_) => SaltNotifier(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MorePass',
      theme: theme,
      home: const AUthGate(),
      routes: {'/themeChoosing': (context) => const ColorThemeChoosePage()},
      scrollBehavior: MyCustomScrollBehavior(),
    );
  }
}
