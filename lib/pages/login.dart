import 'package:flutter/material.dart';
import 'package:myapp/apis/apis.dart';
import 'package:myapp/components/colors.dart';
import 'package:myapp/components/custom_button.dart';
import 'package:myapp/components/textfield.dart';
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
      backgroundColor: darkMode ? secondaryDark : secondaryLight,
      appBar: AppBar(
        backgroundColor: darkMode ? secondaryDark : secondaryLight,
        title: Text(
          "Effettua il login",
          style: TextStyle(color: !darkMode ? secondaryDark : secondaryLight),
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
                CustomTextField(
                    controller: _emailController,
                    leadingIcon: Icons.email_rounded,
                    hint: 'Inserisci email',
                    error: "Inserisci un'email valida"),

                //textfield per la password
                CustomTextField(
                    controller: _passwordController,
                    leadingIcon: Icons.key_rounded,
                    visible: true,
                    hint: 'Inserisci password',
                    error: "Inserisci una password valida"),

                //tasto per la creazione dell'account
                CustomButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          //effettua il login con email e password
                          await SupaBase().signInWithEmailPassword(
                              _passwordController.text, _emailController.text);

                          //setta il tema
                          await setColor();
                          await setDarkMode();
                        } catch (e) {
                          //in caso di errore mostra il messaggio
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                behavior: SnackBarBehavior.floating,
                                content: Text(e.toString())));
                          }
                        }
                      }
                    },
                    text: 'Accedi'),

                const SizedBox(height: 20),

                //tasto per recuperare la password
                TextButton(
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) {
                          final TextEditingController emailController =
                              TextEditingController();

                          final GlobalKey<FormState> formKey =
                              GlobalKey<FormState>();

                          return AlertDialog(
                            content: Form(
                                key: formKey,
                                child: SizedBox(
                                  width: 500,
                                  child: CustomTextField(
                                      controller: emailController,
                                      leadingIcon: Icons.email_rounded,
                                      hint: "Inserisci l'email da recuperare",
                                      error: 'Inserisci la tua email'),
                                )),
                            actions: [
                              //tasto per annullare
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Annulla')),

                              //tasto per inviare l'email di recupero
                              TextButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      //prova ad inviare l'email di recupero
                                      try {
                                        SupaBase().resetPassword(
                                            _emailController.text);
                                      } catch (e) {
                                        //in caso di errore
                                        if (mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  content: Text(e.toString())));
                                        }
                                      } finally {
                                        //se l'invio riesce
                                        if (mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  content: const Text(
                                                      'Controlla la tua casella di posta elettronica')));
                                        }
                                      }
                                    }
                                  },
                                  child: const Text('Invia'))
                            ],
                          );
                        }),
                    child: Text(
                      'Hai dimenticato la password?',
                      style: TextStyle(
                          color: primary, fontWeight: FontWeight.w600),
                    )),

                //tasto per passare alla registrazione
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Hai bisogno di un account?',
                        style: TextStyle(
                            color: darkMode ? secondaryLight : secondaryDark)),
                    TextButton(
                        onPressed: widget.onTap,
                        child: Text(
                          'Registrati',
                          style: TextStyle(
                              color: primary, fontWeight: FontWeight.w600),
                        ))
                  ],
                ),

                SizedBox(
                  width: 900,
                  child: Divider(
                    color: darkMode ? secondaryLight : secondaryDark,
                    thickness: 1,
                  ),
                ),
                const SizedBox(height: 20),

                //tasto per accedere a google
                CustomButton(
                    onPressed: () async => await Supabase.instance.client.auth
                        .signInWithOAuth(OAuthProvider.google),
                    text: 'Accedi con Google',
                    backgroundButtonColor: Colors.red.shade400)
              ],
            ),
          )),
    );
  }
}
