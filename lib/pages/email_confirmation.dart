import 'package:flutter/material.dart';

import '../apis/apis.dart';
import '../components/colors.dart';
import '../components/custom_components/custom_button.dart';
import '../components/custom_components/textfield.dart';

class EmailConfirmation extends StatefulWidget {
  const EmailConfirmation({super.key, required this.email});
  final String email;

  @override
  State<EmailConfirmation> createState() => _EmailConfirmationState();
}

class _EmailConfirmationState extends State<EmailConfirmation> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  @override
  void initState() {
    _emailController.text = widget.email;
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: receiveDarkMode(false),
      body: SafeArea(
          child: SizedBox(
        width: double.infinity,
        child: Container(
          width: 1000,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Form(
            child: Column(
              children: [
                Text(
                  'Conferma la tua email',
                  style: TextStyle(color: receiveDarkMode(true), fontSize: 20, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 10),
                //inserimento dell'email
                CustomTextField(
                    controller: _emailController,
                    leadingIcon: Icons.email_rounded,
                    hint: 'Inserisci email',
                    error: 'Inserisci email',
                    filled: false),

                //inserimento dell'otp
                CustomTextField(
                    controller: _otpController,
                    leadingIcon: Icons.password_rounded,
                    hint: 'Inserisci codice OTP',
                    error: 'Inserisci codice OTP',
                    filled: false),
                const SizedBox(height: 20),

                //tasto per confermare il codice otp
                CustomButton(
                    onPressed: () async {
                      var res = await SupaBase().verifyValidOTPRegistration(_otpController.text, _emailController.text);

                      if (res.session != null) {
                        Navigator.pop(context);
                        //crea il valore nella tabella con le preferenze di default
                        await SupaBase().registerUserPreferencies();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                            behavior: SnackBarBehavior.floating,
                            content: Text('OTP non valido')));
                      }
                    },
                    child: Text('Verifica codice e conferma email'))
              ],
            ),
          ),
        ),
      )),
    );
  }
}
