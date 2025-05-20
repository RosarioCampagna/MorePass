import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:morepass/apis/apis.dart';
import 'package:morepass/apis/password_generator.dart';
import 'package:morepass/components/colors.dart';
import 'package:morepass/components/custom_components/custom_button.dart';
import 'package:morepass/components/custom_components/textfield.dart';
import 'package:morepass/components/route_builder.dart';
import 'package:morepass/pages/email_confirmation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../components/custom_components/psw_manager_strength.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.onTap});

  final void Function()? onTap;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool visibleFirst = false;
  bool visibleSecond = false;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: receiveDarkMode(false),
      appBar: AppBar(
        backgroundColor: receiveDarkMode(false),
        title: Text(
          "Registrati",
          style: TextStyle(color: receiveDarkMode(true)),
        ),
        centerTitle: true,
      ),
      body: Form(
          key: _formKey,
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

                //textfield dell'username
                SizedBox(
                  width: 1000,
                  child: CustomTextField(
                      controller: _usernameController,
                      leadingIcon: Icons.person_rounded,
                      hint: 'Inserisci un nome utente',
                      error: 'Inserisci un nome utente valido',
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
                      onChanged: () => setState(() {}),
                      filled: false),
                ),

                //textfield per la conferma della password
                SizedBox(
                  width: 1000,
                  child: CustomTextField(
                      controller: _passwordConfirmController,
                      leadingIcon: Icons.key_rounded,
                      visible: true,
                      onChanged: () => setState(() {}),
                      hint: 'Inserisci password',
                      error: "Inserisci una password valida",
                      filled: false),
                ),

                if (_passwordController.text.isNotEmpty)
                  //testo per la forza della password
                  Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    width: 1000,
                    child: Column(
                      children: [
                        PswManagerStrength(
                            icon: Icons.abc_rounded,
                            contained: _passwordController.text.includesLower() ||
                                _passwordConfirmController.text.includesLower(),
                            text: 'Lettere minuscole'),
                        PswManagerStrength(
                            icon: Icons.abc_rounded,
                            contained: _passwordController.text.includesUpper() ||
                                _passwordConfirmController.text.includesLower(),
                            text: 'Lettere maiuscole'),
                        PswManagerStrength(
                            icon: Icons.numbers_rounded,
                            contained: _passwordController.text.includesNum() ||
                                _passwordConfirmController.text.includesLower(),
                            text: 'Numeri'),
                        PswManagerStrength(
                            contained: _passwordController.text.includesSym() ||
                                _passwordConfirmController.text.includesLower(),
                            text: 'Simboli',
                            icon: Icons.emoji_symbols_rounded),
                        PswManagerStrength(
                            contained: _passwordController.text == _passwordConfirmController.text,
                            text: _passwordController.text == _passwordConfirmController.text
                                ? 'Le password coincidono'
                                : 'Le password non coincidono',
                            icon: _passwordController.text == _passwordConfirmController.text
                                ? Icons.check_rounded
                                : Icons.close_rounded)
                      ],
                    ),
                  ),

                //tasto per la creazione dell'account
                Container(
                  padding: const EdgeInsets.only(bottom: 5),
                  width: 1000,
                  child: CustomButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_passwordController.text == _passwordConfirmController.text &&
                              _passwordController.text.meetsPasswordRequirement(true, true, true, true)) {
                            //crea l'utente
                            try {
                              await SupaBase().signUpNewUser(
                                  _passwordController.text, _emailController.text, _usernameController.text);
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(e.toString())));
                              }
                            } finally {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    behavior: SnackBarBehavior.floating,
                                    content: const Text(
                                        'Controlla la tua casella di posta elettronica per verificare il tuo account')));
                              }

                              slideUpperNavigatorDialog(EmailConfirmation(), context);
                            }
                          }
                        }
                      },
                      child: Text('Crea utente')),
                ),

                //tasto per tornare alla schermata di login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Hai già un account?', style: TextStyle(color: receiveDarkMode(true))),
                    TextButton(
                        onPressed: widget.onTap,
                        child: Text(
                          'Accedi',
                          style: TextStyle(color: primary, fontWeight: FontWeight.w600),
                        )),
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

                //se non si è su iOS
                if (defaultTargetPlatform != TargetPlatform.iOS)
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
                        child: Text('Registrati con Google', style: const TextStyle(fontWeight: FontWeight.w600))),
                  )
              ],
            ),
          )),
    );
  }
}
