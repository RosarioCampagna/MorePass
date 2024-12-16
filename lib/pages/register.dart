import 'package:flutter/material.dart';
import 'package:myapp/apis/apis.dart';
import 'package:myapp/components/colors.dart';
import 'package:myapp/components/custom_button.dart';
import 'package:myapp/components/textfield.dart';
import 'package:myapp/pages/password_list.dart';

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
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
      backgroundColor: darkMode ? secondaryDark : secondaryLight,
      appBar: AppBar(
        backgroundColor: darkMode ? secondaryDark : secondaryLight,
        title: Text(
          "Registrati",
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

                //textfield dell'username
                CustomTextField(
                    controller: _usernameController,
                    leadingIcon: Icons.person_rounded,
                    hint: 'Inserisci un nome utente',
                    error: 'Inserisci un nome utente valido'),

                //textfield per la password
                CustomTextField(
                    controller: _passwordController,
                    leadingIcon: Icons.key_rounded,
                    visible: true,
                    hint: 'Inserisci password',
                    error: "Inserisci una password valida"),

                //textfield per la conferma della password
                CustomTextField(
                    controller: _passwordConfirmController,
                    leadingIcon: Icons.key_rounded,
                    visible: true,
                    hint: 'Inserisci password',
                    error: "Inserisci una password valida"),

                //tasto per la creazione dell'account
                CustomButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_passwordController.text ==
                            _passwordConfirmController.text) {
                          //crea l'utente
                          try {
                            await SupaBase().signUpNewUser(
                                _passwordController.text,
                                _emailController.text,
                                _usernameController.text);

                            //crea il valore nella tabella con le preferenze di default
                            await SupaBase().registerUserPreferencies();
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(e.toString())));
                            }
                          } finally {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  behavior: SnackBarBehavior.floating,
                                  content: const Text(
                                      'Controlla la tua casella di posta elettronica per verificare il tuo account')));

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PasswordList()));
                            }
                          }
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    content: const Text(
                                        'Le password devono coincidere'),
                                    actionsAlignment: MainAxisAlignment.center,
                                    actions: [
                                      TextButton(
                                          onPressed: () => Navigator.pop,
                                          child: const Text('Okay'))
                                    ],
                                  ));
                        }
                      }
                    },
                    text: 'Crea utente'),

                //tasto per tornare alla schermata di login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Hai già un account?',
                        style: TextStyle(
                            color: darkMode ? secondaryLight : secondaryDark)),
                    TextButton(
                        onPressed: widget.onTap,
                        child: Text(
                          'Accedi',
                          style: TextStyle(
                              color: primary, fontWeight: FontWeight.w600),
                        ))
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
