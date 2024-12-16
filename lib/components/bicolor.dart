import 'package:flutter/material.dart';
import 'package:myapp/components/colors.dart';

class BiColor extends StatelessWidget {
  const BiColor(
      {super.key,
      required this.selected,
      required this.darkMode,
      required this.primaryColor,
      required this.onTap});

  final bool selected;
  final bool darkMode;
  final Color primaryColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: darkMode ? Colors.white : Colors.black87,
            shape: BoxShape.circle,
            border: selected
                ? Border.all(color: Colors.blue.shade800, width: 2)
                : null, /* borderRadius: BorderRadius.circular(12) */
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(100),
                          bottomLeft: Radius.circular(100))),
                  width: 12,
                  height: 24),
              Container(
                  decoration: BoxDecoration(
                      color: darkMode ? secondaryDark : secondaryLight,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(100),
                          bottomRight: Radius.circular(100))),
                  width: 12,
                  height: 24)
            ],
          ),
        ),
      ),
    );
  }
}
