import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morepass/components/page_setter/auth_gate.dart';
import 'package:morepass/components/colors.dart';
import 'package:morepass/components/custom_components/custom_button.dart';
import 'package:morepass/components/custom_components/custom_checkbox.dart';
import 'package:morepass/components/page_setter/settings_page.dart';
import 'package:morepass/components/route_builder.dart';
import '../../apis/password_generator.dart';
import '../../components/desktop_navigator.dart';

class PasswordGeneratorDesktop extends StatefulWidget {
  const PasswordGeneratorDesktop({super.key});

  @override
  State<PasswordGeneratorDesktop> createState() =>
      _PasswordGeneratorDesktopState();
}

class _PasswordGeneratorDesktopState extends State<PasswordGeneratorDesktop> {
  TextEditingController pass = TextEditingController();
  double passLength = 10;
  bool includeLower = true;
  bool includeUpper = true;
  bool includeNumbers = true;
  bool includeSymbols = true;
  bool excludeDuplicated = false;

  @override
  void dispose() {
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pass.text = generatePassword(passLength.round(), excludeDuplicated,
        includeSymbols, includeLower, includeUpper, includeNumbers);
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            //left navigator
            Container(
                height: MediaQuery.of(context).size.height - 10,
                width: 400,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: darkMode
                        ? const Color.fromARGB(255, 40, 40, 40)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12))),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //testo di incoraggiamento
                      Text(
                        'Generatore di password',
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                        softWrap: true,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 20,
                            overflow: TextOverflow.visible,
                            color: receiveDarkMode(true)),
                      ),

                      const SizedBox(height: 40),

                      DesktopNavigatorTile(
                          icon: Icons.key_rounded,
                          selected: false,
                          label: 'Vault',
                          onTap: () => Navigator.pushAndRemoveUntil(
                              context,
                              slideDownNavigator(const AUthGate()),
                              (_) => false)),

                      //navigator che porta alla generazione di password
                      DesktopNavigatorTile(
                          icon: Icons.refresh_rounded,
                          selected: true,
                          label: 'Genera password'),

                      //navigator che porta alle impostazioni
                      DesktopNavigatorTile(
                        icon: Icons.person_outline_rounded,
                        selected: false,
                        label: 'Impostazioni',
                        onTap: () => Navigator.pushAndRemoveUntil(
                            context,
                            slideUpperNavigator(const SettingsPage()),
                            (_) => false),
                      ),
                    ])),
            const SizedBox(width: 25),

            //corpo del widget
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //intestazione della password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Generatore di password',
                            style: TextStyle(
                                color: receiveDarkMode(true),
                                fontSize: 18,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),

                    const SizedBox(height: 20),

                    //textfield dove vedere la password generata
                    TextField(
                      readOnly: true,
                      controller: pass,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: darkMode
                              ? Colors.grey.shade600
                              : Colors.grey.shade300,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none),
                          suffixIcon: IconButton(
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: pass.text));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content:
                                      Text('Password copiata con successo'),
                                  behavior: SnackBarBehavior.floating,
                                ));
                              },
                              icon: const Icon(Icons.copy_all_rounded))),
                    ),

                    const SizedBox(height: 5),

                    //indicatore sulla qualità della password
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                            color: passwordStrenght(pass.text),
                            borderRadius: BorderRadius.circular(100)),
                        height: 4,
                        width: containerWidth(isStrong(pass.text), context),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'Preferenze password',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: receiveDarkMode(true)),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: Text(
                              'Lunghezza della password',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: receiveDarkMode(true)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            passLength.round().toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: receiveDarkMode(true)),
                          )
                        ],
                      ),
                    ),

                    //slider per selezionare la lunghezza della password
                    Slider(
                      min: 8,
                      max: 20,
                      value: passLength,
                      onChanged: (value) {
                        setState(() {
                          passLength = value;
                        });
                      },
                      activeColor: primary,
                      thumbColor: primary,
                    ),

                    const SizedBox(height: 5),

                    //modificatore che aggiunge o esclude le lettere minuscole
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
                      decoration: BoxDecoration(
                          color: receiveDarkMode(true),
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          //includi lettere minuscole
                          CustomCheckbox(
                            selected: includeLower,
                            onChanged: (value) {
                              if (includeNumbers ||
                                  includeSymbols ||
                                  includeUpper) {
                                setState(() {
                                  includeLower = value!;
                                });
                              }
                            },
                            child: Text(
                              'Lettere minuscole',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: receiveDarkMode(false),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),

                          //includi lettere maiuscole
                          CustomCheckbox(
                            selected: includeUpper,
                            onChanged: (value) {
                              if (includeLower ||
                                  includeSymbols ||
                                  includeNumbers) {
                                setState(() {
                                  includeUpper = value!;
                                });
                              }
                            },
                            child: Text(
                              'Lettere maiuscole',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: receiveDarkMode(false),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),

                          //includi numeri
                          CustomCheckbox(
                            selected: includeNumbers,
                            onChanged: (value) {
                              if (includeLower ||
                                  includeSymbols ||
                                  includeUpper) {
                                setState(() {
                                  includeNumbers = value!;
                                });
                              }
                            },
                            child: Text(
                              'Numeri',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: receiveDarkMode(false),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),

                          //includi i caratteri speciali
                          CustomCheckbox(
                            selected: includeSymbols,
                            onChanged: (value) {
                              if (includeNumbers ||
                                  includeLower ||
                                  includeUpper) {
                                setState(() {
                                  includeSymbols = value!;
                                });
                              }
                            },
                            child: Text(
                              'Caratteri speciali',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: receiveDarkMode(false),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),

                          //includi i caratteri speciali
                          CustomCheckbox(
                            selected: excludeDuplicated,
                            onChanged: (value) {
                              setState(() {
                                excludeDuplicated = value!;
                              });
                            },
                            child: Text(
                              'Escludi duplicati',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: receiveDarkMode(false),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),
                    CustomButton(
                      onPressed: () {
                        pass.text = generatePassword(
                            passLength.round(),
                            excludeDuplicated,
                            includeSymbols,
                            includeLower,
                            includeUpper,
                            includeNumbers);
                      },
                      child: Text('Genera Password',
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(width: 25)
          ],
        ),
      ),
    );
  }
}
