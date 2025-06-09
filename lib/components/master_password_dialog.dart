import 'package:flutter/material.dart';
import 'package:morepass/apis/password_generator.dart';
import 'package:morepass/components/colors.dart';
import 'package:morepass/components/custom_components/psw_manager_strength.dart';
import 'package:morepass/components/custom_components/textfield.dart';
import 'package:morepass/master_password_mangement/master_password_notifier.dart';

void showMasterPaswordDialog(context, MasterPasswordNotifier masterPasswordNotifier) {
  if (masterPasswordNotifier.masterPassword != null) {
    return;
  }

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
          //textfield per l'inserimento della password
          content: StatefulBuilder(
            builder: (context, setState) => Form(
                key: formKey,
                child: SizedBox(
                  width: 500,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextField(
                          controller: passwordControllerDialog,
                          leadingIcon: Icons.email_rounded,
                          hint: "Inserisci una password",
                          error: 'Inserisci una password valida',
                          onChanged: () => setState(() {}),
                          filled: false),
                      //testo per la forza della password
                      Container(
                        padding: const EdgeInsets.only(bottom: 20),
                        width: 1000,
                        child: Column(
                          children: [
                            PswManagerStrength(
                                icon: Icons.abc_rounded,
                                contained: passwordControllerDialog.text.includesLower(),
                                text: 'Lettere minuscole'),
                            PswManagerStrength(
                                icon: Icons.abc_rounded,
                                contained: passwordControllerDialog.text.includesUpper(),
                                text: 'Lettere maiuscole'),
                            PswManagerStrength(
                                icon: Icons.numbers_rounded,
                                contained: passwordControllerDialog.text.includesNum(),
                                text: 'Numeri'),
                            PswManagerStrength(
                                contained: passwordControllerDialog.text.includesSym(),
                                text: 'Simboli',
                                icon: Icons.emoji_symbols_rounded),
                            PswManagerStrength(
                                contained:
                                    passwordControllerDialog.text.meetsPasswordRequirement(true, true, true, true) &&
                                        (isStrong(passwordControllerDialog.text) == 'Very strong' ||
                                            isStrong(passwordControllerDialog.text) == 'Strong'),
                                text: passwordControllerDialog.text.meetsPasswordRequirement(true, true, true, true) &&
                                        (isStrong(passwordControllerDialog.text) == 'Very strong' ||
                                            isStrong(passwordControllerDialog.text) == 'Strong')
                                    ? 'Ottima password, rispetta tutti i requisiti'
                                    : 'La password è troppo debole',
                                icon: passwordControllerDialog.text.meetsPasswordRequirement(true, true, true, true) &&
                                        (isStrong(passwordControllerDialog.text) == 'Very strong' ||
                                            isStrong(passwordControllerDialog.text) == 'Strong')
                                    ? Icons.check_rounded
                                    : Icons.close_rounded)
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ),
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
                    if (passwordControllerDialog.text.meetsPasswordRequirement(true, true, true, true) &&
                        (isStrong(passwordControllerDialog.text) == 'Very strong' ||
                            isStrong(passwordControllerDialog.text) == 'Strong')) {
                      //conserva la password
                      await masterPasswordNotifier.setMasterPassword(passwordControllerDialog.text);
                      Navigator.pop(context);
                    }
                  }
                },
                child: Text('Salva', style: TextStyle(color: primary)))
          ],
        );
      });
}
