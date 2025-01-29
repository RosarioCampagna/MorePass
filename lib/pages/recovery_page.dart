import 'package:flutter/material.dart';
import 'package:morepass/apis/apis.dart';
import 'package:morepass/components/colors.dart';
import 'package:morepass/components/custom_components/custom_button.dart';
import 'package:morepass/components/custom_components/textfield.dart';

class RecoveryPage extends StatefulWidget {
  const RecoveryPage({super.key});

  @override
  State<RecoveryPage> createState() => _RecoveryPageState();
}

class _RecoveryPageState extends State<RecoveryPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: receiveDarkMode(false),
      body: SafeArea(
          child: Container(
        width: 1000,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          children: [
            Text(
              'Recupera la tua password',
              style: TextStyle(
                  color: receiveDarkMode(true),
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
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
            CustomButton(
                onPressed: () async {
                  var res = await SupaBase().verifyValidOTP(
                      _otpController.text, _emailController.text);

                  if (res.session != null) {
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        behavior: SnackBarBehavior.floating,
                        content: Text('OTP non valido')));
                  }
                },
                child: Text('Verifica codice'))
          ],
        ),
      )),
    );
  }
}
