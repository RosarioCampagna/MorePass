import 'package:flutter/material.dart';
import 'package:morepass/pages/login.dart';

import '../pages/register.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({super.key});

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  bool login = true;

  void loginRegister() {
    login = !login;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: login
          ? LoginPage(onTap: loginRegister)
          : RegisterPage(onTap: loginRegister),
    );
  }
}
