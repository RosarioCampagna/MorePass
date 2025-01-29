import 'package:flutter/material.dart';
import '../colors.dart';

class CustomRadioButton extends StatelessWidget {
  const CustomRadioButton(
      {super.key,
      required this.groupValue,
      required this.value,
      required this.onChanged,
      required this.child});

  final dynamic groupValue;
  final dynamic value;
  final void Function(dynamic)? onChanged;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      hoverDuration: const Duration(milliseconds: 200),
      hoverColor: darkMode
          ? secondaryLight.withOpacity(0.05)
          : secondaryDark.withOpacity(0.05),
      onTap: () => onChanged!(value),
      child: Row(
        children: [
          Radio(
              value: value,
              activeColor: primary,
              groupValue: groupValue,
              onChanged: onChanged),
          child,
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
