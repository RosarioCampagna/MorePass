import 'package:flutter/cupertino.dart';
import 'package:morepass/components/page_setter/auth_gate.dart';
import 'package:morepass/pages/mobile/password_list_mobile.dart';

class PasswordList extends StatelessWidget {
  const PasswordList({super.key, this.category});
  final String? category;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width < 1000
        ? PasswordListMobile(category: category)
        : AUthGate();
  }
}
