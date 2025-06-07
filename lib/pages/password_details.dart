import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morepass/apis/password_generator.dart';
import 'package:morepass/components/colors.dart';
import 'package:morepass/components/custom_components/custom_button.dart';
import 'package:morepass/components/route_builder.dart';
import 'package:morepass/pages/password_management.dart';

import '../apis/apis.dart';
import '../apis/password.dart';

class PasswordDetails extends StatefulWidget {
  const PasswordDetails({super.key, required this.password});

  final Passwords password;

  @override
  State<PasswordDetails> createState() => _PasswordDetailsState();
}

class _PasswordDetailsState extends State<PasswordDetails> {
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

  bool visible = false;

  String notVisiblePassword(String password) {
    String newPassword = '';
    for (int i = 0; i < password.length; i++) {
      newPassword += '*';
    }
    return newPassword;
  }

  String strongText(String strenght) {
    switch (strenght) {
      case 'Very strong':
        return 'Password molto sicura';
      case 'Strong':
        return 'Password sicura';
      case 'Medium':
        return 'Password media, si consiglia l\'aggiunta di caratteri speciali e numeri (es. "1,2,!,\$")';
      case 'Weak':
        return 'Password debole, si consiglia l\'aggiunta di caratteri speciali e numeri (es. "1,2,!,\$")';
      default:
        return 'Password molto debole, si consiglia di cambiarla';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: receiveDarkMode(false),
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              //icona della password
              Icon(
                setIcon(widget.password.category),
                color: receiveDarkMode(true),
              ),
              const SizedBox(width: 10),

              //nome del provider
              Text(
                widget.password.provider,
                style: TextStyle(color: receiveDarkMode(true), fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),

        //icona per chiudere l'alert
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close_rounded,
                  color: receiveDarkMode(true),
                )),
          )
        ],
      ),
      backgroundColor: receiveDarkMode(false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //sezione dell'username
            Text(
              'Username',
              style: TextStyle(
                  color: darkMode ? Colors.grey.shade600 : Colors.grey.shade400,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),

            const SizedBox(height: 5),

            //testo dell'username
            Row(
              children: [
                //icon dell'username
                Icon(
                  Icons.person_rounded,
                  color: receiveDarkMode(true),
                ),
                const SizedBox(width: 10),

                //testo dell'username
                Text(
                  widget.password.username,
                  style: TextStyle(color: receiveDarkMode(true), fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Divider(color: darkMode ? Colors.grey.shade600 : Colors.grey.shade400, thickness: 1.5),
            ),

            //sezione della password
            Text(
              'Password',
              style: TextStyle(
                  color: darkMode ? Colors.grey.shade600 : Colors.grey.shade400,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),

            const SizedBox(height: 5),

            //testo della password
            Row(
              children: [
                //icona delle password
                Icon(Icons.key_rounded, color: receiveDarkMode(true)),

                const SizedBox(width: 10),

                //testo della password
                Text(
                  visible ? widget.password.password : notVisiblePassword(widget.password.password),
                  style: TextStyle(color: receiveDarkMode(true), fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Spacer(),

                //icona per mostrare/nascondere la password
                IconButton(
                    onPressed: () => setState(() {
                          visible = !visible;
                        }),
                    icon: visible
                        ? Icon(Icons.visibility_off, color: receiveDarkMode(true))
                        : Icon(Icons.visibility, color: receiveDarkMode(true))),

                //tasto per copiare il testo della password
                IconButton(
                    onPressed: () {
                      //copia il testo
                      Clipboard.setData(ClipboardData(text: widget.password.password));

                      //notificalo all'utente
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          behavior: SnackBarBehavior.floating,
                          content: Text('Testo copiato con successo')));
                    },
                    icon: Icon(Icons.copy_rounded, color: receiveDarkMode(true)))
              ],
            ),

            //testo forza della password
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.5),
              child: Text(
                strongText(isStrong(widget.password.password)),
                style: TextStyle(
                    color: passwordStrenght(widget.password.password), fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Divider(color: darkMode ? Colors.grey.shade600 : Colors.grey.shade400, thickness: 1.5),
            ),

            //sezione delle note
            Text(
              'Note',
              style: TextStyle(
                  color: darkMode ? Colors.grey.shade600 : Colors.grey.shade400,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),

            const SizedBox(height: 5),

            //testo delle note
            Row(
              children: [
                //icona delle note
                Icon(
                    const IconData(0xf472,
                        fontFamily: CupertinoIcons.iconFont, fontPackage: CupertinoIcons.iconFontPackage),
                    color: receiveDarkMode(true)),

                const SizedBox(width: 10),

                //testo delle note
                Text(
                  widget.password.notes,
                  style: TextStyle(color: receiveDarkMode(true), fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Divider(color: darkMode ? Colors.grey.shade600 : Colors.grey.shade400, thickness: 1.5),
            ),

            //sezione della categoria
            Text(
              'Categoria',
              style: TextStyle(
                  color: darkMode ? Colors.grey.shade600 : Colors.grey.shade400,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),

            const SizedBox(height: 5),

            //testo della categoria
            Text(
              widget.password.category,
              style: TextStyle(color: receiveDarkMode(true), fontSize: 16, fontWeight: FontWeight.w600),
            ),

            Spacer(),

            //tasto per modificare la password
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: CustomButton(
                      onPressed: () {
                        Navigator.push(context, slideLeftNavigator(PasswordManagement(password: widget.password)));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit_document),
                          const SizedBox(width: 10),
                          Text('Modifica password', style: TextStyle(fontWeight: FontWeight.w600))
                        ],
                      )),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: CustomButton(
                      backgroundButtonColor: Colors.red,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  backgroundColor: darkMode ? secondaryDark : secondaryLight,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  content: Text(
                                      'Sicuro di voler eliminare la password? Questa operazione non è reversibile!',
                                      style: TextStyle(color: darkMode ? secondaryLight : secondaryDark)),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Annulla', style: TextStyle(color: receiveDarkMode(true)))),
                                    TextButton(
                                        onPressed: () async {
                                          await SupaBase().deletePassword(widget.password, 'passwords');
                                          Navigator.pop(context);

                                          //ritorna alla pagina di prima
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Conferma',
                                          style: TextStyle(color: Colors.red),
                                        ))
                                  ],
                                ));
                      },
                      child: Icon(Icons.delete_forever_outlined)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
