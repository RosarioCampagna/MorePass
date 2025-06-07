import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:morepass/apis/apis.dart';
import 'package:morepass/components/colors.dart';
import 'package:morepass/components/custom_components/custom_button.dart';
import 'package:morepass/components/custom_components/textfield.dart';
import 'package:morepass/components/route_builder.dart';
import 'package:morepass/master_password_mangement/master_password_notifier.dart';
import 'package:morepass/pages/email_confirmation.dart';
import 'package:morepass/pages/recovery_page.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.onTap});

  final void Function()? onTap;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: receiveDarkMode(false),
      appBar: AppBar(
        backgroundColor: receiveDarkMode(false),
        title: Text(
          "Effettua il login",
          style: TextStyle(color: receiveDarkMode(true)),
        ),
        centerTitle: true,
      ),
      body: Consumer<MasterPasswordNotifier>(
        builder: (context, masterPasswordNotifier, child) => Form(
            key: _formKey,
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //textfield per l'email
                    SizedBox(
                      width: 1000,
                      child: CustomTextField(
                          controller: _emailController,
                          leadingIcon: Icons.email_rounded,
                          hint: 'Inserisci email',
                          error: "Inserisci un'email valida",
                          filled: false),
                    ),

                    //textfield per la password
                    SizedBox(
                      width: 1000,
                      child: CustomTextField(
                          controller: _passwordController,
                          leadingIcon: Icons.key_rounded,
                          visible: true,
                          hint: 'Inserisci password',
                          error: "Inserisci una password valida",
                          filled: false),
                    ),

                    //tasto per il login dell'account
                    SizedBox(
                      width: 1000,
                      child: CustomButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              //controlla se l'utente ha inserito una master password
                              String? masterPassword = masterPasswordNotifier.masterPassword;

                              //se non l'ha inserita mostra un dialog di inserimento
                              if (masterPassword == null) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      final TextEditingController passwordControllerDialog = TextEditingController();
                                      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

                                      return AlertDialog(
                                        backgroundColor: receiveDarkMode(false),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        title: Text(
                                          'Questa password serve per decifrare il tuo database. \nMettila al sicuro, senza non potrai accedervi.',
                                          style: TextStyle(color: receiveDarkMode(true), fontSize: 18),
                                        ),
                                        content: Form(
                                            key: formKey,
                                            child: SizedBox(
                                              width: 500,
                                              child: CustomTextField(
                                                  controller: passwordControllerDialog,
                                                  leadingIcon: Icons.email_rounded,
                                                  hint: "Inserisci una password",
                                                  error: 'Inserisci una password valida',
                                                  filled: false),
                                            )),
                                        actions: [
                                          //tasto per annullare
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'Annulla',
                                                style: TextStyle(color: receiveDarkMode(true)),
                                              )),

                                          //tasto per conservare la password
                                          TextButton(
                                              onPressed: () async {
                                                if (formKey.currentState!.validate()) {
                                                  //conserva la password
                                                  await masterPasswordNotifier
                                                      .setMasterPassword(passwordControllerDialog.text);

                                                  //effettua il login con email e password
                                                  await SupaBase().signInWithEmailPassword(
                                                      _passwordController.text, _emailController.text);

                                                  //setta il tema
                                                  await setColor();
                                                  await setDarkMode();
                                                }
                                              },
                                              child: Text('Salva', style: TextStyle(color: primary)))
                                        ],
                                      );
                                    });
                              } else {
                                try {
                                  //effettua il login con email e password
                                  await SupaBase()
                                      .signInWithEmailPassword(_passwordController.text, _emailController.text);

                                  //setta il tema
                                  await setColor();
                                  await setDarkMode();
                                } catch (e) {
                                  if (e.toString().contains('email_not_confirmed')) {
                                    SupaBase().sendEmailConfirmation(_emailController.text);
                                    slideUpperNavigatorDialog(EmailConfirmation(), context);
                                  }

                                  //in caso di errore mostra il messaggio
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        behavior: SnackBarBehavior.floating,
                                        content: Text(e.toString())));
                                  }
                                }
                              }
                            }
                          },
                          child: Text('Accedi', style: const TextStyle(fontWeight: FontWeight.w600))),
                    ),

                    const SizedBox(height: 20),

                    //tasto per recuperare la password
                    TextButton(
                        onPressed: () => showDialog(
                            context: context,
                            builder: (context) {
                              final TextEditingController emailController = TextEditingController();

                              final GlobalKey<FormState> formKey = GlobalKey<FormState>();

                              return AlertDialog(
                                backgroundColor: receiveDarkMode(false),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                content: Form(
                                    key: formKey,
                                    child: SizedBox(
                                      width: 500,
                                      child: CustomTextField(
                                          controller: emailController,
                                          leadingIcon: Icons.email_rounded,
                                          hint: "Inserisci l'email da recuperare",
                                          error: 'Inserisci la tua email',
                                          filled: false),
                                    )),
                                actions: [
                                  //tasto per annullare
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        'Annulla',
                                        style: TextStyle(color: receiveDarkMode(true)),
                                      )),

                                  //tasto per inviare l'email di recupero
                                  TextButton(
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          //prova ad inviare l'email di recupero
                                          try {
                                            SupaBase().resetPassword(emailController.text);
                                          } catch (e) {
                                            //in caso di errore
                                            if (mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                  shape:
                                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                  behavior: SnackBarBehavior.floating,
                                                  content: Text(e.toString())));
                                            }
                                          } finally {
                                            //se l'invio riesce
                                            if (mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                  shape:
                                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                  behavior: SnackBarBehavior.floating,
                                                  content: const Text(
                                                      'Controlla la tua casella di posta elettronica, se l\'email non è presente controlla lo spam')));
                                              Navigator.pop(context);

                                              slideUpperNavigatorDialog(RecoveryPage(), context);
                                            }
                                          }
                                        }
                                      },
                                      child: Text('Invia', style: TextStyle(color: primary)))
                                ],
                              );
                            }),
                        child: Text(
                          'Hai dimenticato la password?',
                          style: TextStyle(color: primary, fontWeight: FontWeight.w600),
                        )),

                    //tasto per passare alla registrazione
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Hai bisogno di un account?', style: TextStyle(color: receiveDarkMode(true))),
                        TextButton(
                            onPressed: widget.onTap,
                            child: Text(
                              'Registrati',
                              style: TextStyle(color: primary, fontWeight: FontWeight.w600),
                            ))
                      ],
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: 1000,
                      child: Divider(
                        color: receiveDarkMode(true),
                        thickness: 1,
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (defaultTargetPlatform != TargetPlatform.iOS || defaultTargetPlatform != TargetPlatform.windows)
                      //tasto per accedere a google
                      SizedBox(
                        width: 1000,
                        child: CustomButton(
                            onPressed: () async {
                              if (!kIsWeb && Platform.isAndroid) {
                                await SupaBase().signInWithGoogle();
                                return;
                              }

                              await Supabase.instance.client.auth.signInWithOAuth(OAuthProvider.google,
                                  authScreenLaunchMode:
                                      kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication);
                            },
                            backgroundButtonColor: Colors.red.shade400,
                            child: Text('Accedi con Google', style: const TextStyle(fontWeight: FontWeight.w600))),
                      )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
