import 'package:flutter/material.dart';
import 'package:myapp/apis/apis.dart';
import 'package:myapp/apis/encryption.dart';
import 'package:myapp/apis/password.dart';
import 'package:myapp/components/colors.dart';
import 'package:myapp/components/custom_list_tile.dart';
import 'package:myapp/components/textfield.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'password_management.dart';
import 'settings.dart';

class PasswordList extends StatefulWidget {
  const PasswordList({super.key});

  @override
  State<PasswordList> createState() => _PasswordListState();
}

class _PasswordListState extends State<PasswordList> {
  final TextEditingController _searchBar = TextEditingController();

  @override
  void initState() {
    setColor();
    setDarkMode();
    super.initState();
  }

  @override
  void dispose() {
    _searchBar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: darkMode ? secondaryDark : secondaryLight,
        appBar: AppBar(
          leading: IconButton(

              //tasto per andare alle impostazioni dell'account
              onPressed: () => Navigator.push(
                  (context),
                  MaterialPageRoute(
                      builder: (context) => const SettingsPage())),
              icon: Icon(Icons.settings_rounded, color: secondaryLight)),

          //intestazione della pagina
          title: Text(
            Supabase.instance.client.auth.currentUser!.userMetadata!.entries
                .firstWhere((value) => value.key == 'displayName')
                .value,
            style: TextStyle(color: secondaryLight),
          ),
          centerTitle: true,
          backgroundColor: primary,
        ),

        //tasto per aggiungere utenti
        floatingActionButton: FloatingActionButton(
            backgroundColor: primary,
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PasswordManagement())),
            child: Icon(Icons.add_rounded, color: secondaryLight)),

        //lista degli utenti nel database
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //textfield per cercare le pasword
                CustomTextField(
                  controller: _searchBar,
                  leadingIcon: Icons.search_rounded,
                  hint: 'Cerca',
                  error: 'error',
                  onChanged: () => setState(() {}),
                ),

                //ascolta i cambiamenti all'interno del database nella tabella "passwords"
                StreamBuilder(
                    stream: _searchBar.text.isNotEmpty
                        ? SupaBase()
                            .getSearchedPasswords('passwords', _searchBar.text)
                        : SupaBase().getPasswords('passwords'),
                    builder: (context, snapshot) {
                      //se la lista sta caricando
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      //in caso di qualche errore
                      if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      }

                      //istanza della lista degli utenti
                      final passwords = snapshot.data;
                      if (passwords!.isEmpty) {
                        return Center(
                            child: Text('Nessuna password trovata',
                                style: TextStyle(
                                    color: secondaryLight, fontSize: 20)));
                      }

                      //lista degli utenti
                      return SizedBox(
                        width: 1000,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, passwordsIndex) {
                              //istanza del singolo utente
                              final password = passwords[passwordsIndex];

                              final decryptedPassword = Passwords(
                                  id: password.id,
                                  provider: Encryption()
                                      .decryptData(password.provider),
                                  username: Encryption()
                                      .decryptData(password.username),
                                  password: Encryption()
                                      .decryptData(password.password),
                                  notes:
                                      Encryption().decryptData(password.notes),
                                  creato: password.creato);

                              return CustomListTile(
                                  password: decryptedPassword,
                                  onTilePress: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PasswordManagement(
                                                  password:
                                                      decryptedPassword))),
                                  onPressed: () => showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            content: const Text(
                                                'Sicuro di voler eliminare la password? Questa operazione non è reversibile!'),
                                            actionsAlignment:
                                                MainAxisAlignment.center,
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text('Annulla',
                                                      style: TextStyle(
                                                          color: primary))),
                                              TextButton(
                                                  onPressed: () async {
                                                    await SupaBase()
                                                        .deletePassword(
                                                            password,
                                                            'passwords');

                                                    Navigator.pop(context);
                                                    setState(() {});
                                                  },
                                                  child: const Text('Conferma',
                                                      style: TextStyle(
                                                          color: Colors.red)))
                                            ],
                                          )));
                            },
                            itemCount: passwords.length),
                      );
                    }),
              ],
            ),
          ),
        ));
  }
}
