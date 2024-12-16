import 'package:flutter/material.dart';
import 'package:myapp/components/colors.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.icon,
      this.trailingIcon,
      this.color});

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? trailingIcon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1000,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(color: primary),
        color: darkMode ? Colors.black87 : Colors.white70,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          //icona del tile
          Icon(icon,
              color: darkMode ? secondaryLight : secondaryDark, size: 28),

          const SizedBox(width: 20),

          //titolo e sottotitolo del tile
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //titolo
              Stack(
                children: [
                  Text(title,
                      style: TextStyle(
                          foreground: Paint()
                            ..color = darkMode ? Colors.black87 : Colors.white
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 2.5,
                          fontSize: 18)),
                  Text(title,
                      style: TextStyle(
                          color: color ?? primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 18)),
                ],
              ),

              const SizedBox(height: 5),

              //sottotitolo
              Stack(
                children: [
                  Text(subtitle,
                      style: TextStyle(
                          foreground: Paint()
                            ..color = darkMode ? Colors.black87 : Colors.white
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 2.2,
                          fontSize: 14)),
                  Text(
                    subtitle,
                    style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  ),
                ],
              )
            ],
          ),
          const Spacer(),

          //se c'è un widget alla fine o no
          trailingIcon != null ? trailingIcon! : const SizedBox.shrink()
        ],
      ),
    );
  }
}
