import 'package:flutter/material.dart';
import 'package:morepass/apis/apis.dart';
import 'package:morepass/apis/encryption.dart';
import 'package:morepass/apis/password.dart';
import 'package:morepass/components/page_setter/auth_gate.dart';
import 'package:morepass/components/colors.dart';
import 'package:morepass/components/custom_components/custom_list_tile.dart';
import 'package:morepass/components/custom_components/custom_radio.dart';
import 'package:morepass/components/navbar/navbar.dart';
import 'package:morepass/components/navbar/navbar_component.dart';
import 'package:morepass/components/custom_components/textfield.dart';
import 'package:morepass/components/page_setter/password_generator_page.dart';
import 'package:morepass/components/page_setter/settings_page.dart';
import 'package:morepass/pages/password_details.dart';

import '../../components/route_builder.dart';
import '../password_management.dart';

class PasswordListMobile extends StatefulWidget {
  const PasswordListMobile({super.key, this.category});
  final String? category;

  @override
  State<PasswordListMobile> createState() => _PasswordListMobileState();
}

class _PasswordListMobileState extends State<PasswordListMobile> {
  final TextEditingController _searchBar = TextEditingController();

  bool ascending = true;
  String sorting = 'Provider';
  String categoryFilter = 'Tutto';

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
          psw.sort((a, b) =>
              DateTime.parse(b.creato!).compareTo(DateTime.parse(a.creato!)));
          break;
        }

        psw.sort((a, b) =>
            DateTime.parse(a.creato!).compareTo(DateTime.parse(b.creato!)));
    }
  }

  List<Passwords> filterByCategory(List<Passwords> psw) {
    if (categoryFilter != 'Tutto') {
      psw = psw
          .where((password) =>
              Encryption().decryptData(password.category) == categoryFilter)
          .toList();
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
    return Scaffold(
        backgroundColor: receiveDarkMode(false),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          //intestazione della pagina
          title: Text(
            'Password',
            style: TextStyle(color: receiveDarkMode(true)),
          ),
          centerTitle: true,
          backgroundColor: receiveDarkMode(false),
          actions: [
            IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close_rounded))
          ],
        ),

        //tasto per aggiungere password
        floatingActionButton: FloatingActionButton(
            backgroundColor: primary,
            onPressed: () =>
                slideUpperNavigatorDialog(PasswordManagement(), context),
            child: Icon(Icons.add_rounded, color: secondaryLight)),

        //bottom nav bar
        bottomNavigationBar: NavBar(
          items: [
            //navbar che porta alla homepage
            NavbarComponent(
                icon: Icons.home_outlined,
                selected: false,
                label: 'Home',
                onTap: () => Navigator.pushAndRemoveUntil(context,
                    slideRightNavigator(const AUthGate()), (_) => false)),

            //nav bar della pagina corrente
            NavbarComponent(
                icon: Icons.key_rounded, selected: true, label: 'Vault'),

            //navbar che porta al password generator
            NavbarComponent(
                icon: Icons.refresh_rounded,
                selected: false,
                label: 'Genera',
                onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    slideLeftNavigator(const PasswordGeneratorPage()),
                    (_) => false)),

            //navbar che porta alle impostazioni
            NavbarComponent(
                icon: Icons.person_outline_rounded,
                selected: false,
                label: 'Impostazioni',
                onTap: () => Navigator.pushAndRemoveUntil(context,
                    slideLeftNavigator(const SettingsPage()), (_) => false)),
          ],
        ),

        //lista degli utenti nel database
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(children: [
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

                  //tasto per ordinare la lista delle password
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    hoverColor: receiveDarkMode(true).withAlpha(13),
                    hoverDuration: const Duration(milliseconds: 200),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            bool alertAscending = ascending;
                            String alertSorting = sorting;
                            String alertCategoryFilter = categoryFilter;

                            return StatefulBuilder(
                                builder: (context, setAlertState) {
                              return AlertDialog(
                                backgroundColor: receiveDarkMode(false),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),

                                //titolo dell'alert
                                title: Text(
                                  'Ordina le password',
                                  style:
                                      TextStyle(color: receiveDarkMode(true)),
                                ),

                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    //testo per il filtro di ordinamento
                                    Text(
                                      'Filtri di ordinamento:',
                                      style: TextStyle(
                                          color: receiveDarkMode(true),
                                          fontWeight: FontWeight.w600),
                                    ),

                                    const SizedBox(height: 10),

                                    //entrate ordinamento ascendente/discendente
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        //ordinamento per provider
                                        CustomRadioButton(
                                            value: 'Provider',
                                            groupValue: alertSorting,
                                            onChanged: (value) =>
                                                setAlertState(() {
                                                  alertSorting = value!;
                                                }),
                                            child: Text('Provider',
                                                style: TextStyle(
                                                    color:
                                                        receiveDarkMode(true),
                                                    fontWeight:
                                                        FontWeight.w600))),

                                        //ordinamento per data
                                        CustomRadioButton(
                                            value: 'Data',
                                            groupValue: alertSorting,
                                            onChanged: (value) =>
                                                setAlertState(() {
                                                  alertSorting = value!;
                                                }),
                                            child: Text('Data',
                                                style: TextStyle(
                                                    color:
                                                        receiveDarkMode(true),
                                                    fontWeight:
                                                        FontWeight.w600)))
                                      ],
                                    ),

                                    //divisore
                                    Divider(color: receiveDarkMode(true)),

                                    const SizedBox(height: 10),

                                    //riga per ordinamento ascendente/discendente
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        //ordinamento ascendente
                                        CustomRadioButton(
                                          value: true,
                                          groupValue: alertAscending,
                                          onChanged: (value) =>
                                              setAlertState(() {
                                            alertAscending = value!;
                                          }),
                                          child: Text('Ascendente',
                                              style: TextStyle(
                                                  color: receiveDarkMode(true),
                                                  fontWeight: FontWeight.w600)),
                                        ),

                                        //ordinamento discendente
                                        CustomRadioButton(
                                            groupValue: alertAscending,
                                            value: false,
                                            onChanged: (value) =>
                                                setAlertState(() {
                                                  alertAscending = value!;
                                                }),
                                            child: Text('Discendente',
                                                style: TextStyle(
                                                    color:
                                                        receiveDarkMode(true),
                                                    fontWeight:
                                                        FontWeight.w600)))
                                      ],
                                    ),

                                    const SizedBox(height: 10),

                                    //inizia l'ordinamento anche per categoria
                                    Text(
                                      'Categoria:',
                                      style: TextStyle(
                                          color: receiveDarkMode(true),
                                          fontWeight: FontWeight.w600),
                                    ),

                                    const SizedBox(height: 10),

                                    //prima riga di filtri
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        //filtro per tutto
                                        CustomRadioButton(
                                            groupValue: alertCategoryFilter,
                                            value: 'Tutto',
                                            onChanged: (value) =>
                                                setAlertState(() {
                                                  alertCategoryFilter = value!;
                                                }),
                                            child: Text('Tutto',
                                                style: TextStyle(
                                                    color:
                                                        receiveDarkMode(true),
                                                    fontWeight:
                                                        FontWeight.w600))),

                                        //filtro per login
                                        CustomRadioButton(
                                            groupValue: alertCategoryFilter,
                                            value: 'Login',
                                            onChanged: (value) =>
                                                setAlertState(() {
                                                  alertCategoryFilter = value!;
                                                }),
                                            child: Text('Login',
                                                style: TextStyle(
                                                    color:
                                                        receiveDarkMode(true),
                                                    fontWeight:
                                                        FontWeight.w600))),
                                      ],
                                    ),

                                    //seconda riga di filtri
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        //filtro per wifi
                                        CustomRadioButton(
                                            groupValue: alertCategoryFilter,
                                            value: 'Wifi',
                                            onChanged: (value) =>
                                                setAlertState(() {
                                                  alertCategoryFilter = value!;
                                                }),
                                            child: Text('Wifi',
                                                style: TextStyle(
                                                    color:
                                                        receiveDarkMode(true),
                                                    fontWeight:
                                                        FontWeight.w600))),

                                        //filtro per altro
                                        CustomRadioButton(
                                            groupValue: alertCategoryFilter,
                                            value: 'Altro',
                                            onChanged: (value) =>
                                                setAlertState(() {
                                                  alertCategoryFilter = value!;
                                                }),
                                            child: Text('Altro',
                                                style: TextStyle(
                                                    color:
                                                        receiveDarkMode(true),
                                                    fontWeight:
                                                        FontWeight.w600))),
                                      ],
                                    ),
                                  ],
                                ),
                                actions: [
                                  //tasto per annullare la selezione
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Annulla',
                                          style: TextStyle(
                                              color: receiveDarkMode(true)))),

                                  //tasto per confermare la selezione
                                  TextButton(
                                      onPressed: () => setState(() {
                                            sorting = alertSorting;
                                            ascending = alertAscending;
                                            categoryFilter =
                                                alertCategoryFilter;
                                            Navigator.pop(context);
                                          }),
                                      child: Text('Conferma',
                                          style: TextStyle(color: primary)))
                                ],
                              );
                            });
                          });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //chiave d'ordinamento
                          Text(sorting,
                              style: TextStyle(
                                  color: receiveDarkMode(true), fontSize: 18)),

                          //categoria
                          Text(' ($categoryFilter)',
                              style: TextStyle(
                                  color: receiveDarkMode(true), fontSize: 18)),
                          const SizedBox(width: 5),

                          //icona dell'ordinamento
                          Icon(
                            ascending
                                ? Icons.arrow_upward_rounded
                                : Icons.arrow_downward_rounded,
                            color: receiveDarkMode(true),
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),

                const SizedBox(height: 10),

                //ascolta i cambiamenti all'interno del database nella tabella "passwords"
                Expanded(
                  child: StreamBuilder(
                      stream: SupaBase()
                          .getSearchedPasswords('passwords', _searchBar.text),
                      builder: (context, snapshot) {
                        //se la lista sta caricando
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: CircularProgressIndicator(color: primary));
                        }

                        //in caso di qualche errore
                        if (snapshot.hasError) {
                          return Center(child: Text(snapshot.error.toString()));
                        }

                        //istanza della lista degli utenti
                        List<Passwords> passwords = snapshot.data!;

                        //ordina la lista
                        orderBy(passwords);

                        if (widget.category != null ||
                            categoryFilter != 'Tutto') {
                          passwords = filterByCategory(passwords);
                        }

                        //se non ci sono password mostra un widget
                        if (passwords.isEmpty) {
                          return Center(
                              child: Text('Nessuna password trovata',
                                  style: TextStyle(
                                      color: receiveDarkMode(true),
                                      fontSize: 20)));
                        }

                        //lista delle password
                        return ListView.builder(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            physics: BouncingScrollPhysics(),
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
                                  category: Encryption()
                                      .decryptData(password.category),
                                  creato: password.creato);

                              return CustomListTile(
                                  password: decryptedPassword,
                                  onTilePress: () => slideUpperNavigatorDialog(
                                      PasswordDetails(
                                          password: decryptedPassword),
                                      context),
                                  onPressed: () => showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            backgroundColor:
                                                receiveDarkMode(false),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            content: Text(
                                              'Sicuro di voler eliminare la password? Questa operazione non è reversibile!',
                                              style: TextStyle(
                                                  color: receiveDarkMode(true)),
                                            ),
                                            actionsAlignment:
                                                MainAxisAlignment.center,
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text('Annulla',
                                                      style: TextStyle(
                                                          color:
                                                              receiveDarkMode(
                                                                  true)))),
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
                            itemCount: passwords.length);
                      }),
                ),
              ],
            ),
          ),
        ));
  }
}
