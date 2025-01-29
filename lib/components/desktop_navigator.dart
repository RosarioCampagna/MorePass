import 'package:flutter/material.dart';

import 'colors.dart';

class DesktopNavigatorTile extends StatelessWidget {
  const DesktopNavigatorTile(
      {super.key,
      required this.icon,
      required this.selected,
      required this.label,
      this.onTap});

  final IconData icon;
  final bool selected;
  final String label;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        mouseCursor: SystemMouseCursors.click,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              color: selected ? primary : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: !selected ? Colors.grey.shade600 : Colors.transparent)),
          child: Row(
            //icon del tile
            children: [
              Icon(
                icon,
                color: !selected ? Colors.grey.shade600 : Colors.grey.shade100,
              ),
              const SizedBox(width: 10),

              //testo del tile
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                          color: !selected ? Colors.grey.shade600 : Colors.grey.shade100,
                          fontSize: selected ? 16 : 14,
                          fontWeight: FontWeight.w600,
                          wordSpacing: 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
