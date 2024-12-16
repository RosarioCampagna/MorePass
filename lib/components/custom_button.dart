import 'package:flutter/material.dart';
import 'package:myapp/components/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.backgroundButtonColor});

  final void Function()? onPressed;
  final String text;
  final Color? backgroundButtonColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          backgroundColor:
              WidgetStatePropertyAll(backgroundButtonColor ?? primary),
          foregroundColor: WidgetStatePropertyAll(secondaryLight),
          minimumSize: const WidgetStatePropertyAll(Size(1000, 50)),
          maximumSize: const WidgetStatePropertyAll(Size(double.infinity, 50))),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
