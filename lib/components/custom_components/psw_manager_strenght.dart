import 'package:flutter/material.dart';

class PswManagerStrenght extends StatelessWidget {
  const PswManagerStrenght(
      {super.key,
      required this.contained,
      required this.text,
      required this.icon});

  final bool contained;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //icona
        Icon(
          icon,
          color: contained ? Colors.green : Colors.grey.shade600,
        ),
        const SizedBox(width: 10),

        //testo
        Text(
          text,
          style: TextStyle(
              color: contained ? Colors.green : Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w400),
        )
      ],
    );
  }
}
