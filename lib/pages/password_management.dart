import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:morepass/apis/apis.dart';
import 'package:morepass/apis/password.dart';
import 'package:morepass/apis/password_generator.dart';
import 'package:morepass/components/custom_components/custom_button.dart';
import 'package:morepass/components/custom_components/textfield.dart';
import 'package:morepass/components/page_setter/password_generator_page.dart';
import 'package:morepass/components/route_builder.dart';

import '../components/colors.dart';

class PasswordManagement extends StatefulWidget {
  const PasswordManagement({super.key, this.password});

  final Passwords? password;

  @override
  State<PasswordManagement> createState() => _PasswordManagementState();
}

class _PasswordManagementState extends State<PasswordManagement> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //editing controller di tutti i textfield
  final TextEditingController _providerController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String category = 'Login';

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
  void initState() {
    if (widget.password != null) {
      _providerController.text = widget.password!.provider;
      _usernameController.text = widget.password!.username;
      _passwordController.text = widget.password!.password;
      _notesController.text = widget.password!.notes;
      category = widget.password!.category;
    }

    super.initState();
  }

  @override
  void dispose() {
    _providerController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: receiveDarkMode(false),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: receiveDarkMode(false),
        title: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            widget.password != null
                ? 'Dettagli password'
                : 'Aggiungi la password',
            style: TextStyle(color: receiveDarkMode(true)),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close_rounded, color: receiveDarkMode(true))),
          )
        ],
      ),
      body: Center(
        child: Form(
            key: _formKey,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 5),
                    //textfield del provider
                    CustomTextField(
                        leadingIcon: Icons.web_asset_rounded,
                        hint: 'Provider',
                        error: 'Inserire un provider',
                        controller: _providerController,
                        filled: false),

                    // textfiel dell'username
                    CustomTextField(
                        leadingIcon: Icons.person,
                        hint: 'Username',
                        error: 'Inserire un username',
                        controller: _usernameController,
                        filled: false),

                    //textfield della password
                    CustomTextField(
                        leadingIcon: Icons.key_rounded,
                        hint: 'Password',
                        error: 'Inserire una password',
                        controller: _passwordController,
                        filled: false,
                        onChanged: () => setState(() {}),
                        visible: true),

                    //forza della password
                    if (_passwordController.text.isNotEmpty)
                      Container(
                        padding: EdgeInsets.only(bottom: 15, left: 10),
                        width: MediaQuery.of(context).size.width > 1000
                            ? 1000
                            : double.infinity,
                        child: Wrap(
                          children: [
                            const SizedBox(width: 12),
                            Text(
                              '${strongText(isStrong(_passwordController.text))}. ',
                              style: TextStyle(
                                  color: passwordStrenght(
                                      _passwordController.text),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                            if (isStrong(_passwordController.text) !=
                                    'Very strong' &&
                                isStrong(_passwordController.text) != 'Strong')
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      slideLeftNavigator(
                                          PasswordGeneratorPage()));
                                },
                                child: Text(
                                  'Prova il nostro generatore di password!',
                                  style: TextStyle(
                                      color: primary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                          ],
                        ),
                      ),

                    //textfield delle note
                    CustomTextField(
                        leadingIcon: const IconData(0xf472,
                            fontFamily: CupertinoIcons.iconFont,
                            fontPackage: CupertinoIcons.iconFontPackage),
                        hint: 'Note',
                        error: 'Inserire una nota',
                        controller: _notesController,
                        filled: false),

                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          color: receiveDarkMode(false),
                          border: Border.all(color: primary, width: 2),
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Categoria:',
                            style: TextStyle(
                                color: receiveDarkMode(true), fontSize: 16),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                style: TextStyle(
                                    color: receiveDarkMode(true), fontSize: 16),
                                dropdownColor: receiveDarkMode(false),
                                borderRadius: BorderRadius.circular(12),
                                value: category,
                                items: ['Login', 'Wifi', 'Altro']
                                    .map((item) => DropdownMenuItem(
                                          value: item,
                                          child: Text(item),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    category = value!;
                                  });
                                }),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    //tasto per inserire la password
                    CustomButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            //controlla se la password esiste
                            if (widget.password != null) {
                              //modifica la password
                              SupaBase().updatePassword(
                                  widget.password!,
                                  Passwords(
                                      provider: _providerController.text,
                                      username: _usernameController.text,
                                      password: _passwordController.text,
                                      notes: _notesController.text.isEmpty
                                          ? 'Nessuna nota'
                                          : _notesController.text,
                                      category: category));
                            } else {
                              //inserisci la password
                              SupaBase().insertPassword(Passwords(
                                  provider: _providerController.text,
                                  username: _usernameController.text,
                                  password: _passwordController.text,
                                  notes: _notesController.text.isEmpty
                                      ? 'Nessuna nota'
                                      : _notesController.text,
                                  category: category));
                            }

                            //ritorna alla pagina di prima
                            Navigator.pop(context);
                          }
                        },
                        child: widget.password != null
                            ? Text('Aggiorna Password',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600))
                            : Text('Aggiungi password',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600))),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
