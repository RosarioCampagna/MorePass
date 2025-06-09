import 'dart:async';

import 'package:flutter/material.dart';
import 'package:morepass/apis/apis.dart';
import 'package:morepass/apis/password.dart';
import 'package:morepass/components/page_setter/auth_gate.dart';
import 'package:morepass/components/custom_components/bicolor.dart';
import 'package:morepass/components/custom_components/custom_button.dart';
import 'package:morepass/components/custom_components/custom_list_tile.dart';
import 'package:morepass/components/custom_components/settings_tile.dart';
import 'package:morepass/components/custom_components/textfield.dart';
import 'package:morepass/master_password_mangement/master_password_notifier.dart';
import 'package:provider/provider.dart';

import '../components/colors.dart';
import '../components/route_builder.dart';

class ColorThemeChoosePage extends StatefulWidget {
  const ColorThemeChoosePage({super.key});

  @override
  State<ColorThemeChoosePage> createState() => _ColorThemeChoosePageState();
}

class _ColorThemeChoosePageState extends State<ColorThemeChoosePage> {
  String color = 'orange';

  //funzione che controlla il tema dell'applicazione
  void setPrimaryColor(Color color, String color2, bool dark) {
    primary = color;
    this.color = color2;
    darkMode = dark;
    setState(() {});
  }

  Color? oldPrimary;
  bool? oldDarkMode;

  @override
  void initState() {
    oldPrimary = primary;
    oldDarkMode = darkMode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkMode ? secondaryDark : secondaryLight,
      appBar: AppBar(
          backgroundColor: darkMode ? secondaryDark : secondaryLight,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                primary = oldPrimary!;
                darkMode = oldDarkMode!;
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: darkMode ? secondaryLight : secondaryDark)),
          title: Text(
            'Scegli il tuo tema',
            style: TextStyle(color: darkMode ? secondaryLight : secondaryDark),
          ),
          centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //textfield
              SizedBox(
                width: 1000,
                child: CustomTextField(
                    controller: TextEditingController(),
                    leadingIcon: Icons.person_rounded,
                    hint: 'Questo è un inserimento di testo con questo tema',
                    error: 'Questo è un errore di testo con questo tema',
                    filled: false),
              ),

              const SizedBox(height: 20),

              //tasto
              SizedBox(
                width: 1000,
                child: CustomButton(
                    onPressed: () {},
                    child:
                        Text('Questo è un tasto con questo tema', style: const TextStyle(fontWeight: FontWeight.w600))),
              ),

              const SizedBox(height: 20),

              //list tile
              SizedBox(
                width: 1000,
                child: CustomListTile(
                    password: Passwords(
                        provider: 'Questa è una voce in una lista ',
                        username: 'username',
                        password: 'password',
                        category: '',
                        notes: 'con questo tema'),
                    onPressed: () {},
                    onTilePress: () {}),
              ),

              const SizedBox(height: 20),

              //settings tile
              // ignore: prefer_const_constructors
              SizedBox(
                width: 1000,
                child: SettingsTile(
                    title: 'Questo è un tile delle impostazioni',
                    subtitle: 'con questo tema',
                    icon: Icons.settings_rounded),
              ),

              const SizedBox(height: 20),

              //tema scuro
              SizedBox(
                width: 1000,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //arancione intema scuro
                    BiColor(
                        onTap: () async {
                          setPrimaryColor(orange, 'orange', true);
                        },
                        primaryColor: orange,
                        selected: primary == orange && darkMode,
                        darkMode: true),

                    const SizedBox(width: 20),

                    //rosso intema scuro
                    BiColor(
                        onTap: () async {
                          setPrimaryColor(red, 'red', true);
                        },
                        primaryColor: red,
                        selected: primary == red && darkMode,
                        darkMode: true),

                    const SizedBox(width: 20),

                    //blu in tema scuro
                    BiColor(
                        onTap: () {
                          setPrimaryColor(blue, 'blue', true);
                        },
                        primaryColor: blue,
                        selected: primary == blue && darkMode,
                        darkMode: true),

                    const SizedBox(width: 20),

                    //viola in tema scuro
                    BiColor(
                        onTap: () {
                          setPrimaryColor(purple, 'purple', true);
                        },
                        primaryColor: purple,
                        selected: primary == purple && darkMode,
                        darkMode: true),

                    const SizedBox(width: 20),

                    //verde in tema scuro
                    BiColor(
                        onTap: () {
                          setPrimaryColor(green, 'green', true);
                        },
                        primaryColor: green,
                        selected: primary == green && darkMode,
                        darkMode: true),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              //tema chiaro
              SizedBox(
                width: 1000,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //arancione in tema chiaro
                    BiColor(
                        onTap: () async {
                          setPrimaryColor(orange, 'orange', false);
                        },
                        primaryColor: orange,
                        selected: primary == orange && !darkMode,
                        darkMode: false),

                    const SizedBox(width: 20),

                    //rosso in tema chiaro
                    BiColor(
                        onTap: () async {
                          setPrimaryColor(red, 'red', false);
                        },
                        primaryColor: red,
                        selected: primary == red && !darkMode,
                        darkMode: false),

                    const SizedBox(width: 20),

                    //blu in tema chiaro
                    BiColor(
                        onTap: () {
                          setPrimaryColor(blue, 'blue', false);
                        },
                        primaryColor: blue,
                        selected: primary == blue && !darkMode,
                        darkMode: false),

                    const SizedBox(width: 20),

                    //viola in tema chiaro
                    BiColor(
                        onTap: () {
                          setPrimaryColor(purple, 'purple', false);
                        },
                        primaryColor: purple,
                        selected: primary == purple && !darkMode,
                        darkMode: false),

                    const SizedBox(width: 20),

                    //verde in tema chiaro
                    BiColor(
                        onTap: () {
                          setPrimaryColor(green, 'green', false);
                        },
                        primaryColor: green,
                        selected: primary == green && !darkMode,
                        darkMode: false),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              //tasto che conferma il cambiamento del colore
              SizedBox(
                width: 1000,
                child: CustomButton(
                    onPressed: () async {
                      //aggiorna il tema
                      await SupaBase().updateTheme(color, darkMode);

                      //aggiorna il tema
                      await setColor();
                      await setDarkMode();

                      //controlla che non sia la prima volta che si effettua il login
                      if ((await SupaBase().getFirstTime()).first['first'] == true) {
                        SupaBase().updateFirstTime();
                      }

                      if (ModalRoute.of(context)!.settings.name == '/themeChoosing') {
                        //mostra un dialog con le informazioni necessarie
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  backgroundColor: receiveDarkMode(false),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircularProgressIndicator(color: primary),
                                      const SizedBox(height: 10),
                                      Text('Per rendere effettivo il cambiamento rieffettua il login',
                                          style: TextStyle(color: receiveDarkMode(true)))
                                    ],
                                  ),
                                ));
                      }

                      //fa sparire il caricamento dopo un tot di secondi
                      Future.delayed(const Duration(seconds: 3)).then((onValue) async {
                        Navigator.pop(context);

                        //mostra un messaggio che dice che il tema è aggiornato
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            content: Text('Tema aggiornato con successo')));

                        //se la route non è /themeChoosing allora ritorna a questa pagina
                        if (ModalRoute.of(context)!.settings.name == '/themeChoosing') {
                          //riporta alla pagina di login
                          Navigator.pushAndRemoveUntil(context, slideLeftNavigator(AUthGate()), (_) => false);

                          Provider.of<MasterPasswordNotifier>(context, listen: false).deleteMasterPassword();

                          //effettua il logout
                          SupaBase().signOut();
                        }
                      });
                    },
                    child: Text('Conferma', style: const TextStyle(fontWeight: FontWeight.w600))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
