import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:morepass/apis/apis.dart';
import 'package:morepass/components/page_setter/auth_gate.dart';
import 'package:morepass/components/custom_components/custom_button.dart';
import 'package:morepass/components/navbar/navbar.dart';
import 'package:morepass/components/page_setter/password_generator_page.dart';
import 'package:morepass/components/page_setter/password_list.dart';
import 'package:morepass/components/route_builder.dart';
import 'package:morepass/components/custom_components/settings_tile.dart';
import 'package:morepass/components/custom_components/textfield.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../components/colors.dart';
import '../../components/navbar/navbar_component.dart';

class SettingsPageMobile extends StatefulWidget {
  const SettingsPageMobile({super.key});

  @override
  State<SettingsPageMobile> createState() => _SettingsPageMobileState();
}

class _SettingsPageMobileState extends State<SettingsPageMobile> {
  bool isGoogleLinked() {
    final List<UserIdentity> identities =
        Supabase.instance.client.auth.currentUser!.identities!;

    for (UserIdentity identity in identities) {
      if (identity.provider == 'google') {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    isGoogleLinked();
    return Scaffold(
      backgroundColor: receiveDarkMode(false),
      appBar: AppBar(
        backgroundColor: receiveDarkMode(false),
        title: Text(
          'Impostazioni',
          style: TextStyle(color: receiveDarkMode(true)),
        ),
        centerTitle: true,
      ),

      //bottom nav bar
      bottomNavigationBar: NavBar(
        items: [
          //parte del bottom nav bar che reindirizza alla home
          NavbarComponent(
              icon: Icons.home_outlined,
              selected: false,
              label: 'Home',
              onTap: () => Navigator.pushAndRemoveUntil(context,
                  slideRightNavigator(const AUthGate()), (_) => false)),

          //parte del bottom nav bar che reindirizza alla pagina delle password
          NavbarComponent(
              icon: Icons.key_outlined,
              selected: false,
              label: 'Vault',
              onTap: () => Navigator.pushAndRemoveUntil(context,
                  slideRightNavigator(const PasswordList()), (_) => false)),

          //parte del bottom nav bar che reindirizza alla generazione di una password
          NavbarComponent(
              icon: Icons.refresh_rounded,
              selected: false,
              label: 'Genera',
              onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  slideRightNavigator(const PasswordGeneratorPage()),
                  (_) => false)),

          //parte del bottom nav bar che reindirizza alle impostazioni
          NavbarComponent(
            icon: Icons.person_rounded,
            selected: true,
            label: 'Impostazioni',
          ),
        ],
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
                    color: receiveDarkMode(true),
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            final TextEditingController newUsernameController =
                                TextEditingController();

                            final GlobalKey<FormState> formKey =
                                GlobalKey<FormState>();

                            return AlertDialog(
                              backgroundColor: receiveDarkMode(false),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              content: Form(
                                  key: formKey,
                                  child: SizedBox(
                                    width: 500,
                                    child: CustomTextField(
                                        controller: newUsernameController,
                                        leadingIcon: Icons.person_rounded,
                                        hint: 'Nuovo username',
                                        error: 'Inserisci nuovo username',
                                        filled: false),
                                  )),
                              actionsAlignment: MainAxisAlignment.center,
                              actions: [
                                //tasto per annullare
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      'Annulla',
                                      style: TextStyle(
                                          color: receiveDarkMode(true)),
                                    )),

                                //tasto per confermare
                                TextButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        await SupaBase().updateUsername(
                                            newUsernameController.text);
                                        setState(() {});
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text('Conferma',
                                        style: TextStyle(color: primary))),
                              ],
                            );
                          });
                    },
                    icon: const Icon(Icons.settings_rounded)),
              ),

              //tasto che reindirizza alla scelta del tema
              CustomButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/themeChoosing'),
                  child: Text('Cambia il tema dell\'app',
                      style: const TextStyle(fontWeight: FontWeight.w600))),

              const Spacer(),

              Row(
                children: [
                  if (defaultTargetPlatform != TargetPlatform.iOS)
                    if (!isGoogleLinked())
                      Expanded(
                        child: CustomButton(
                            onPressed: () async {
                              await Supabase.instance.client.auth
                                  .linkIdentity(OAuthProvider.google);
                            },
                            backgroundButtonColor: Colors.red.shade400,
                            child: Text('Collega account Google',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600))),
                      )
                    else
                      Expanded(
                        child: CustomButton(
                            onPressed: () async {
                              await Supabase.instance.client.auth
                                  .unlinkIdentity(Supabase.instance.client.auth
                                      .currentUser!.identities!
                                      .firstWhere((identity) =>
                                          identity.provider == 'google'));
                            },
                            backgroundButtonColor: Colors.red.shade400,
                            child: Text('Scollega account Google',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600))),
                      ),
                ],
              ),

              const SizedBox(height: 10),

              //tasto per effettuare il logout
              CustomButton(
                  onPressed: () {
                    SupaBase().signOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        slideLeftNavigator(const AUthGate()),
                        (predicate) => false);
                  },
                  backgroundButtonColor: const Color.fromARGB(255, 192, 39, 29),
                  child: Text('Logout',
                      style: const TextStyle(fontWeight: FontWeight.w600))),

              const SizedBox(height: 20),

              //tasto per inoltrare la richiesta di eliminazione dell'account
              CustomButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              backgroundColor: receiveDarkMode(false),
                              content: Text(
                                'Sei sicuro di voler inoltrare una richiesta di eliminazione dell\'account? L\'operazione non sarà reversibile e tutte le password verranno eliminate!',
                                style: TextStyle(
                                    color: receiveDarkMode(true),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      'Annulla',
                                      style: TextStyle(
                                          color: receiveDarkMode(true)),
                                    )),
                                TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Conferma',
                                      style: TextStyle(color: Colors.red),
                                    ))
                              ],
                            ));
                  },
                  backgroundButtonColor: const Color.fromARGB(255, 192, 39, 29),
                  child: Text('Elimina account',
                      style: const TextStyle(fontWeight: FontWeight.w600))),
            ],
          ),
        ),
      ),
    );
  }
}
