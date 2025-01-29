import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:morepass/apis/password.dart';
import '../colors.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile(
      {super.key,
      required this.password,
      this.onPressed,
      required this.onTilePress});

  final Passwords password;
  final void Function()? onPressed;
  final void Function()? onTilePress;

  IconData filterIcon(String category) {
    //icona del wifi
    const IconData wifi = IconData(0xf89b,
        fontFamily: CupertinoIcons.iconFont,
        fontPackage: CupertinoIcons.iconFontPackage);

    //icona del globo
    const IconData globe = IconData(0xf68d,
        fontFamily: CupertinoIcons.iconFont,
        fontPackage: CupertinoIcons.iconFontPackage);

    switch (category) {
      case 'Wifi':
        return wifi;
      case 'Login':
        return globe;
      default:
        return Icons.key_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: primary,
      child: ListTile(
        //naviga alla descrizione della password
        onTap: onTilePress,
        dense: true,
        visualDensity: const VisualDensity(vertical: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(filterIcon(password.category), color: secondaryLight),
        title: Text(
          password.provider,
          style: TextStyle(color: secondaryLight, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          password.notes,
          style: TextStyle(color: Colors.grey.shade200),
        ),
        trailing: onPressed != null
            ? IconButton(
                onPressed: onPressed,
                icon: Icon(
                  Icons.delete_forever_rounded,
                  color: secondaryLight,
                ))
            : Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(width: 1.5, color: secondaryLight),
                    shape: BoxShape.circle),
                child: Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: secondaryLight)),
      ),
    );
  }
}
