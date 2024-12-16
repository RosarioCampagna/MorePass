import 'package:flutter/material.dart';
import 'package:myapp/apis/apis.dart';
import 'package:myapp/components/custom_button.dart';
import 'package:myapp/components/settings_tile.dart';
import 'package:myapp/components/textfield.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../components/colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkMode ? secondaryDark : secondaryLight,
      appBar: AppBar(
        backgroundColor: darkMode ? secondaryDark : secondaryLight,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: darkMode ? secondaryLight : secondaryDark)),
        title: Text(
          'Impostazioni',
          style: TextStyle(color: darkMode ? secondaryLight : secondaryDark),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //tile to display email
              SettingsTile(
                title: 'Email',
                subtitle: Supabase.instance.client.auth.currentUser!.email!,
                icon: Icons.email_rounded,
              ),

              //tile for the username
              SettingsTile(
                title: 'Username',
                subtitle: Supabase
                    .instance.client.auth.currentUser!.userMetadata!.entries
                    .firstWhere((value) => value.key == 'displayName')
                    .value,
                icon: Icons.person_rounded,
                //tasto per modificare l'username
                trailingIcon: IconButton(
                    color: darkMode ? secondaryLight : secondaryDark,
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            final TextEditingController newUsernameController =
                                TextEditingController();

                            final GlobalKey<FormState> formKey =
                                GlobalKey<FormState>();

                            return AlertDialog(
                              content: Form(
                                  key: formKey,
                                  child: SizedBox(
                                    width: 500,
                                    child: CustomTextField(
                                        controller: newUsernameController,
                                        leadingIcon: Icons.person_rounded,
                                        hint: 'Nuovo username',
                                        error: 'Inserisci nuovo username'),
                                  )),
                              actionsAlignment: MainAxisAlignment.center,
                              actions: [
                                //tasto per annullare
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Annulla')),

                                //tasto per confermare
                                TextButton(
                                    onPressed: () async {
                                      await SupaBase().updateUsername(
                                          newUsernameController.text);
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Conferma')),
                              ],
                            );
                          });
                    },
                    icon: const Icon(Icons.settings_rounded)),
              ),
              const Spacer(),

              //tasto che reindirizza alla scelta del tema
              CustomButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/themeChoosing'),
                  text: 'Cambia il tema dell\'app'),

              const SizedBox(height: 10),

              //tasto per effettuare il logout
              CustomButton(
                  onPressed: () {
                    SupaBase().signOut();
                    Navigator.pop(context);
                  },
                  text: 'Logout',
                  backgroundButtonColor:
                      const Color.fromARGB(255, 192, 39, 29)),

              //se l'email dell'account non è confermata mostra il tasto
              if (!SupaBase().checkEmailConfirmation())
                CustomButton(
                    onPressed: () {
                      //invia l'email di conferma
                      SupaBase().sendEmailConfirmation();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            behavior: SnackBarBehavior.floating,
                            content: const Text(
                                'Controlla la tua casella di posta elettronica')));
                      }
                    },
                    text: 'Invia email di conferma'),
            ],
          ),
        ),
      ),
    );
  }
}
