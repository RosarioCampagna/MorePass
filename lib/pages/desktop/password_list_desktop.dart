import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:morepass/apis/apis.dart';
import 'package:morepass/cypher/encryption.dart';
import 'package:morepass/apis/password.dart';
import 'package:morepass/components/colors.dart';
import 'package:morepass/components/custom_components/custom_list_tile.dart';
import 'package:morepass/components/custom_components/custom_radio.dart';
import 'package:morepass/components/desktop_navigator.dart';
import 'package:morepass/components/custom_components/textfield.dart';
import 'package:morepass/components/page_setter/password_generator_page.dart';
import 'package:morepass/components/page_setter/settings_page.dart';
import 'package:morepass/cypher/master_password_notifier.dart';
import 'package:morepass/pages/password_details.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../components/custom_components/custom_button.dart';
import '../../components/custom_components/homepage_tile.dart';
import '../../components/route_builder.dart';
import '../password_management.dart';

class PasswordListDesktop extends StatefulWidget {
  const PasswordListDesktop({super.key, this.category});
  final String? category;

  @override
  State<PasswordListDesktop> createState() => _PasswordListDesktopState();
}

class _PasswordListDesktopState extends State<PasswordListDesktop> {
  final TextEditingController _searchBar = TextEditingController();

  bool ascending = true;
  String sorting = 'Provider';
  String categoryFilter = 'Tutto';
  String? masterPassword = '';

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

  void orderBy(List<Passwords> psw) {
    switch (sorting) {
      case 'Provider':
        sorting = 'Provider';
        if (!ascending) {
          psw.sort((a, b) => b.provider.compareTo(a.provider));

          break;
        }
        psw.sort((a, b) => a.provider.compareTo(b.provider));
        break;

      default:
        sorting = 'Data';
        if (!ascending) {
          psw.sort((a, b) => DateTime.parse(b.creato!).compareTo(DateTime.parse(a.creato!)));
          break;
        }

        psw.sort((a, b) => DateTime.parse(a.creato!).compareTo(DateTime.parse(b.creato!)));
    }
  }

  List<Passwords> filterByCategory(List<Passwords> psw) {
    if (categoryFilter != 'Tutto') {
      psw = psw.where((password) => Encryption().decryptData(password.category) == categoryFilter).toList();
    }

    return psw;
  }

  @override
  void initState() {
    setColor();
    setDarkMode();
    if (widget.category != null) categoryFilter = widget.category!;

    super.initState();
  }

  @override
  void dispose() {
    _searchBar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /* final masterPasswordNotifier = Provider.of<MasterPasswordNotifier>(context);
    print(masterPasswordNotifier.masterPassword); */
    return Scaffold(
        backgroundColor: receiveDarkMode(false),
        //tasto per aggiungere password
        floatingActionButton: FloatingActionButton(
            backgroundColor: primary,
            onPressed: () => slideUpperNavigatorDialog(PasswordManagement(), context),
            child: Icon(Icons.add_rounded, color: secondaryLight)),

        //lista degli utenti nel database
        body: Row(
          children: [
            Container(
                width: 400,
                height: MediaQuery.of(context).size.height - 10,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: darkMode ? const Color.fromARGB(255, 40, 40, 40) : Colors.grey.shade300,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12))),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    //header della barra laterale
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

                    //testo di incoraggiamento
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
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(45, 255, 255, 255), shape: BoxShape.circle),
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
                                child: Text('Aggiungi nuova password',
                                    style: const TextStyle(fontWeight: FontWeight.w600)))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    //lista delle password per categoria
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

                          final List<Passwords> passwords = snapshot.data!;

                          //filtra tutto per categoria
                          List<String> passCategories = [];

                          for (Passwords password in passwords) {
                            if (!passCategories.contains(password.category)) {
                              passCategories.add(password.category);
                            }
                          }

                          return SizedBox(
                            height: 150,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              children: [
                                //password totali salvate
                                HomepageTile(
                                    onTap: () => categoryFilter != 'Tutto'
                                        ? setState(() {
                                            categoryFilter = 'Tutto';
                                          })
                                        : null,
                                    passwordCategory: 'Password Salvate',
                                    passwordNumber: passwords.length,
                                    icon: Icons.key_rounded),
                                const SizedBox(width: 2.5),

                                //per ogni categoria presente crea un tile della categoria
                                for (var category in passCategories)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2.5),
                                    child: HomepageTile(
                                        //reindirizza alla categoria selezionata
                                        onTap: () => setState(() {
                                              categoryFilter = Encryption().decryptData(category);
                                            }),

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
                          );
                        }),
                    const SizedBox(height: 10),

                    //filtri d'ordinamento
                    Text(
                      'Filtri di ordinamento:',
                      style: TextStyle(color: receiveDarkMode(true), fontWeight: FontWeight.w600),
                    ),

                    const SizedBox(height: 10),

                    //entrate ordinamento ascendente/discendente
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //ordinamento per provider
                        Expanded(
                          child: DesktopNavigatorTile(
                              onTap: () => setState(() {
                                    sorting = 'Provider';
                                  }),
                              icon: Icons.web_rounded,
                              selected: sorting == 'Provider',
                              label: 'Provider'),
                        ),

                        const SizedBox(width: 10),

                        //ordinamento per data
                        Expanded(
                          child: DesktopNavigatorTile(
                              onTap: () => setState(() {
                                    sorting = 'Data';
                                  }),
                              icon: Icons.date_range_rounded,
                              selected: sorting == 'Data',
                              label: 'Data'),
                        ),
                      ],
                    ),

                    //divisore
                    Divider(color: receiveDarkMode(true)),

                    const SizedBox(height: 10),

                    //riga per ordinamento ascendente/discendente
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //ordinamento ascendente
                        CustomRadioButton(
                          value: true,
                          groupValue: ascending,
                          onChanged: (value) => setState(() {
                            ascending = value!;
                          }),
                          child: Text('Ascendente',
                              style: TextStyle(color: receiveDarkMode(true), fontWeight: FontWeight.w600)),
                        ),

                        //ordinamento discendente
                        CustomRadioButton(
                            groupValue: ascending,
                            value: false,
                            onChanged: (value) => setState(() {
                                  ascending = value!;
                                }),
                            child: Text('Discendente',
                                style: TextStyle(color: receiveDarkMode(true), fontWeight: FontWeight.w600)))
                      ],
                    ),

                    const SizedBox(height: 10),

                    //navigator che porta alla pagina di vault
                    DesktopNavigatorTile(icon: Icons.key_rounded, selected: true, label: 'Vault'),

                    //navigator che porta alla generazione di password
                    DesktopNavigatorTile(
                      icon: Icons.refresh_rounded,
                      selected: false,
                      label: 'Genera password',
                      onTap: () => Navigator.pushAndRemoveUntil(
                          context, slideUpperNavigator(const PasswordGeneratorPage()), (_) => false),
                    ),

                    //navigator che porta alle impostazioni
                    DesktopNavigatorTile(
                      icon: Icons.person_outline_rounded,
                      selected: false,
                      label: 'Impostazioni',
                      onTap: () => Navigator.pushAndRemoveUntil(
                          context, slideUpperNavigator(const SettingsPage()), (_) => false),
                    ),

                    const SizedBox(height: 10),

                    //tasto per effettuare il logout
                    CustomButton(
                        backgroundButtonColor: Colors.red,
                        onPressed: () {
                          SupaBase().signOut();
                        },
                        child: Text('Logout'))
                  ]),
                )),

            //lista delle password
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //textfield per cercare le password
                    CustomTextField(
                      controller: _searchBar,
                      leadingIcon: Icons.search_rounded,
                      hint: 'Cerca',
                      error: 'error',
                      filled: false,
                      onChanged: () => setState(() {}),
                    ),

                    const SizedBox(height: 20),

                    //ascolta i cambiamenti all'interno del database nella tabella "passwords"
                    Expanded(
                      child: StreamBuilder(
                          stream: SupaBase().getSearchedPasswords('passwords', _searchBar.text),
                          builder: (context, snapshot) {
                            //se la lista sta caricando
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator(color: primary));
                            }

                            //in caso di qualche errore
                            if (snapshot.hasError) {
                              return Center(child: Text(snapshot.error.toString()));
                            }

                            //istanza della lista degli utenti
                            List<Passwords> passwords = snapshot.data!;

                            //ordina la lista
                            orderBy(passwords);

                            if (widget.category != null || categoryFilter != 'Tutto') {
                              passwords = filterByCategory(passwords);
                            }

                            //se non ci sono password mostra un widget
                            if (passwords.isEmpty) {
                              return Center(
                                  child: Text('Nessuna password trovata',
                                      style: TextStyle(color: receiveDarkMode(true), fontSize: 20)));
                            }

                            //lista degli utenti
                            return ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, passwordsIndex) {
                                  //istanza del singolo utente
                                  final password = passwords[passwordsIndex];

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
                                          PasswordDetails(password: decryptedPassword), context),
                                      onPressed: () => showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                backgroundColor: receiveDarkMode(false),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                content: Text(
                                                  'Sicuro di voler eliminare la password? Questa operazione non è reversibile!',
                                                  style: TextStyle(color: receiveDarkMode(true)),
                                                ),
                                                actionsAlignment: MainAxisAlignment.center,
                                                actions: [
                                                  TextButton(
                                                      onPressed: () => Navigator.pop(context),
                                                      child: Text('Annulla',
                                                          style: TextStyle(color: receiveDarkMode(true)))),
                                                  TextButton(
                                                      onPressed: () async {
                                                        await SupaBase().deletePassword(password, 'passwords');

                                                        Navigator.pop(context);
                                                        setState(() {});
                                                      },
                                                      child:
                                                          const Text('Conferma', style: TextStyle(color: Colors.red)))
                                                ],
                                              )));
                                },
                                itemCount: passwords.length);
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
