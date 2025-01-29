import 'package:flutter/material.dart';
import 'package:morepass/components/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.onPressed,
      this.backgroundButtonColor,
      required this.child});

  final void Function()? onPressed;
  final Color? backgroundButtonColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
            backgroundColor:
                WidgetStatePropertyAll(backgroundButtonColor ?? primary),
            foregroundColor: WidgetStatePropertyAll(
                backgroundButtonColor == Colors.grey.shade100
                    ? Colors.grey.shade900
                    : secondaryLight),
            minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 50)),
            maximumSize:
                const WidgetStatePropertyAll(Size(double.infinity, 50))),
        child: child);
  }
}
