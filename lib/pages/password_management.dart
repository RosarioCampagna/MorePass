import 'package:flutter/material.dart';
import 'package:myapp/apis/apis.dart';
import 'package:myapp/apis/password.dart';
import 'package:myapp/components/custom_button.dart';
import 'package:myapp/components/textfield.dart';
import 'package:myapp/pages/password_list.dart';

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

  @override
  void initState() {
    if (widget.password != null) {
      _providerController.text = widget.password!.provider;
      _usernameController.text = widget.password!.username;
      _passwordController.text = widget.password!.password;
      _notesController.text = widget.password!.notes;
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
      backgroundColor: darkMode ? secondaryDark : secondaryLight,
      appBar: AppBar(
        backgroundColor: darkMode ? secondaryDark : secondaryLight,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: darkMode ? secondaryLight : secondaryDark)),
        title: Text(
          'Aggiungi la password',
          style: TextStyle(color: !darkMode ? secondaryDark : secondaryLight),
        ),
        centerTitle: true,
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //textfield del provider
                  CustomTextField(
                      leadingIcon: Icons.web_asset_rounded,
                      hint: 'Provider',
                      error: 'Inserire un provider',
                      controller: _providerController),

                  // textfiel dell'username
                  CustomTextField(
                      leadingIcon: Icons.person,
                      hint: 'Username',
                      error: 'Inserire un username',
                      controller: _usernameController),

                  //textfield della password
                  CustomTextField(
                      leadingIcon: Icons.key_rounded,
                      hint: 'Password',
                      error: 'Inserire una password',
                      controller: _passwordController,
                      visible: true),

                  //textfield delle note
                  CustomTextField(
                      leadingIcon: Icons.note_rounded,
                      hint: 'Note',
                      error: 'Inserire una nota',
                      controller: _notesController),

                  //tasto per inserire la password
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: CustomButton(
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
                                          : _notesController.text));
                            } else {
                              //inserisci la password
                              SupaBase().insertPassword(Passwords(
                                  provider: _providerController.text,
                                  username: _usernameController.text,
                                  password: _passwordController.text,
                                  notes: _notesController.text.isEmpty
                                      ? 'Nessuna nota'
                                      : _notesController.text));
                            }

                            //ritorna alla pagina di prima
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PasswordList()),
                                (_) => false);
                          }
                        },
                        text: widget.password != null
                            ? 'Aggiorna Password'
                            : 'Aggiungi password'),
                  ),

                  if (widget.password != null)
                    //tasto per eliminare la password
                    CustomButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    content: const Text(
                                        'Sicuro di voler eliminare la password? Questa operazione non è reversibile!'),
                                    actionsAlignment: MainAxisAlignment.center,
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Annulla',
                                              style: TextStyle(
                                                  color: Colors.red))),
                                      TextButton(
                                          onPressed: () async {
                                            await SupaBase().deletePassword(
                                                widget.password!, 'passwords');
                                            Navigator.pop(context);

                                            //ritorna alla pagina di prima
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const PasswordList()),
                                                (_) => false);
                                          },
                                          child: const Text('Conferma'))
                                    ],
                                  ));
                        },
                        text: 'Elimina password'),
                ],
              ),
            ),
          )),
    );
  }
}
