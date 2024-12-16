import 'package:flutter/material.dart';
import 'package:myapp/apis/password.dart';
import 'colors.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile(
      {super.key,
      required this.password,
      required this.onPressed,
      required this.onTilePress});

  final Passwords password;
  final void Function()? onPressed;
  final void Function()? onTilePress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        //naviga alla descrizione della password
        onTap: onTilePress,
        visualDensity: const VisualDensity(vertical: 1),
        tileColor: primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(Icons.web_rounded, color: secondaryLight),
        title: Text(
          password.provider,
          style: TextStyle(color: secondaryLight, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          password.notes,
          style: TextStyle(color: Colors.grey.shade200),
        ),
        trailing: IconButton(
            onPressed: onPressed,
            icon: Icon(
              Icons.delete_forever_rounded,
              color: secondaryLight,
            )),
      ),
    );
  }
}
