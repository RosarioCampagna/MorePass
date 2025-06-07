import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:morepass/apis/apis.dart';
import 'package:morepass/apis/password.dart';
import 'package:morepass/components/colors.dart';
import 'package:morepass/components/custom_components/custom_button.dart';
import 'package:morepass/components/custom_components/custom_list_tile.dart';
import 'package:morepass/components/custom_components/homepage_tile.dart';
import 'package:morepass/components/page_setter/password_generator_page.dart';
import 'package:morepass/components/page_setter/password_list.dart';
import 'package:morepass/components/page_setter/settings_page.dart';
import 'package:morepass/pages/password_details.dart';
import 'package:morepass/pages/password_management.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../cypher/encryption.dart';
import '../../components/navbar/navbar.dart';
import '../../components/navbar/navbar_component.dart';
import '../../components/route_builder.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  IconData setIcon(String category) {
    const IconData globe =
        IconData(0xf68d, fontFamily: CupertinoIcons.iconFont, fontPackage: CupertinoIcons.iconFontPackage);
    switch (category) {
      case 'Login':
        return globe;
      case 'Wifi':
        return Icons.wifi_rounded;
      default:
        return Icons.key_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          /* appBar: AppBar(
            backgroundColor: receiveDarkMode(false),
            toolbarHeight: 100,
            flexibleSpace:

                //messaggio di bentornato + nome
                Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: 'Bentornato, ',
                          style: TextStyle(
                              color: receiveDarkMode(true),
                              fontSize: 16,
                              fontWeight: FontWeight.w400)),

                      //nome utente
                      TextSpan(
                          text:
                              '${Supabase.instance.client.auth.currentUser!.userMetadata!.entries.firstWhere((element) => element.key == 'displayName').value}',
                          style: TextStyle(
                              color: receiveDarkMode(true),
                              fontSize: 24,
                              fontWeight: FontWeight.w600))
                    ]),
                  ),
                  Text(
                    'Metti al sicuro le tue password grazie al nostro metodo di cifratura!',
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                    softWrap: true,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 16,
                        overflow: TextOverflow.visible,
                        color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ), */
          backgroundColor: receiveDarkMode(false),

          //bottom nav bar
          bottomNavigationBar: NavBar(
            items: [
              //parte del bottom nav bar che reindirizza alla home
              NavbarComponent(icon: Icons.home_rounded, selected: true, label: 'Home'),

              //parte del bottom nav bar che reindirizza alla pagina delle password
              NavbarComponent(
                  icon: Icons.key_outlined,
                  selected: false,
                  label: 'Vault',
                  onTap: () => Navigator.pushAndRemoveUntil(context, slideLeftNavigator(PasswordList()), (_) => false)),

              //parte del bottom nav bar che reindirizza alla generazione di una password
              NavbarComponent(
                  icon: Icons.refresh_rounded,
                  selected: false,
                  label: 'Genera',
                  onTap: () =>
                      Navigator.pushAndRemoveUntil(context, slideLeftNavigator(PasswordGeneratorPage()), (_) => false)),

              //parte del bottom nav bar che reindirizza alle impostazioni
              NavbarComponent(
                  icon: Icons.person_outline_rounded,
                  selected: false,
                  label: 'Impostazioni',
                  onTap: () => Navigator.pushAndRemoveUntil(context, slideLeftNavigator(SettingsPage()), (_) => false)),
            ],
          ),
          body: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),

            //dichiara il body come scrollable
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: 'Bentornato, ',
                          style: TextStyle(color: receiveDarkMode(true), fontSize: 16, fontWeight: FontWeight.w400)),

                      //nome utente
                      TextSpan(
                          text:
                              '${Supabase.instance.client.auth.currentUser!.userMetadata!.entries.firstWhere((element) => element.key == 'displayName').value}',
                          style: TextStyle(color: receiveDarkMode(true), fontSize: 24, fontWeight: FontWeight.w600))
                    ]),
                  ),
                  Text(
                    'Metti al sicuro le tue password grazie al nostro metodo di cifratura!',
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                    softWrap: true,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16, overflow: TextOverflow.visible, color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 10),

                  //container con la creazione delle password
                  Card(
                    color: primary,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(top: 5),
                      width: 1000,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Icona del container
                          Container(
                              padding: const EdgeInsets.all(8),
                              decoration:
                                  BoxDecoration(color: const Color.fromARGB(45, 255, 255, 255), shape: BoxShape.circle),
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade100, width: 1.5),
                                    shape: BoxShape.circle),
                                child: Icon(Icons.person_outline_rounded, color: Colors.grey.shade100),
                              )),

                          const SizedBox(height: 10),

                          //intestazione
                          Text(
                            'Nuove password',
                            style: TextStyle(color: Colors.grey.shade100, fontSize: 18, fontWeight: FontWeight.w600),
                          ),

                          //Sottotitolo
                          Text(
                            'Aggiungi le tue password con facilità',
                            style: TextStyle(color: Colors.grey.shade300, fontSize: 14, fontWeight: FontWeight.w400),
                          ),

                          const SizedBox(height: 20),

                          //tasto per aggiungere una password
                          CustomButton(
                              onPressed: () => slideUpperNavigatorDialog(PasswordManagement(), context),
                              backgroundButtonColor: Colors.grey.shade100,
                              child:
                                  Text('Aggiungi nuova password', style: const TextStyle(fontWeight: FontWeight.w600)))
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  //stream builder con le informazioni sulle password
                  StreamBuilder(
                      stream: SupaBase().getSearchedPasswords('passwords', ''),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator(color: primary));
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text(
                            snapshot.error.toString(),
                            style: TextStyle(color: receiveDarkMode(true)),
                          ));
                        }

                        List<Passwords> passwords = snapshot.data!;

                        passwords.sort((a, b) => b.creato!.compareTo(a.creato!));

                        List<Passwords> last5pass;
                        int endList = 5;

                        //se ci sono meno di 5 password, allora prendi tutte
                        if (passwords.length < 5) {
                          endList = passwords.length;
                        }
                        last5pass = passwords.getRange(0, endList).toList();

                        //filtra tutto per categoria
                        List<String> passCategories = [];

                        for (Passwords password in passwords) {
                          if (!passCategories.contains(password.category)) {
                            passCategories.add(password.category);
                          }
                        }

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 150,
                              child: ListView(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                children: [
                                  //tile del totale delle password salvate
                                  HomepageTile(
                                      onTap: () => Navigator.pushAndRemoveUntil(
                                          context, slideRightNavigator(PasswordList()), (_) => false),
                                      icon: Icons.key_rounded,
                                      passwordCategory: 'Password salvate',
                                      passwordNumber: passwords.length),
                                  const SizedBox(width: 2.5),

                                  //per ogni categoria presente crea un tile della categoria
                                  for (var category in passCategories)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 2.5),
                                      child: HomepageTile(
                                          //reindirizza alla categoria selezionata
                                          onTap: () => Navigator.pushAndRemoveUntil(
                                              context,
                                              slideRightNavigator(
                                                  PasswordList(category: Encryption().decryptData(category))),
                                              (_) => false),

                                          //titolo della categoria
                                          passwordCategory: Encryption().decryptData(category),

                                          //numero di password presenti in categoria
                                          passwordNumber: passwords
                                              .where((password) => password.category == category)
                                              .toList()
                                              .length,
                                          icon: setIcon(Encryption().decryptData(category))),
                                    )
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            //test della lista delle password
                            Row(
                              children: [
                                Text(
                                  'Ultime password salvate',
                                  style: TextStyle(
                                      color: receiveDarkMode(true), fontSize: 16, fontWeight: FontWeight.w600),
                                )
                              ],
                            ),

                            const SizedBox(height: 10),

                            //lista delle password ordinata dalla più recente alla meno recente
                            //limite a 5 password

                            if (last5pass.isNotEmpty)
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: last5pass.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, passwordsIndex) {
                                    Passwords password = last5pass[passwordsIndex];

                                    final decryptedPassword = Passwords(
                                        id: password.id,
                                        provider: Encryption().decryptData(password.provider),
                                        username: Encryption().decryptData(password.username),
                                        password: Encryption().decryptData(password.password),
                                        notes: Encryption().decryptData(password.notes),
                                        category: Encryption().decryptData(password.category),
                                        creato: password.creato);

                                    return CustomListTile(
                                        password: decryptedPassword,
                                        onTilePress: () => slideUpperNavigatorDialog(
                                            PasswordDetails(password: decryptedPassword), context));
                                  })
                            else
                              Text(
                                'Nessuna password salvata',
                                style:
                                    TextStyle(color: receiveDarkMode(true), fontSize: 18, fontWeight: FontWeight.w600),
                              )
                          ],
                        );
                      }),
                ],
              ),
            ),
          )),
    );
  }
}
