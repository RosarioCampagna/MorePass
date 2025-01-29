import 'package:flutter/material.dart';

import '../colors.dart';

class NavbarComponent extends StatelessWidget {
  const NavbarComponent(
      {super.key,
      required this.icon,
      required this.selected,
      this.label,
      this.onTap});

  final IconData icon;
  final bool selected;
  final String? label;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              padding: const EdgeInsets.all(2),
              height: selected ? 34 : 24,
              decoration: BoxDecoration(
                  border: !selected
                      ? Border.all(color: Colors.grey, width: 1.5)
                      : null,
                  shape: BoxShape.circle),
              child: FittedBox(
                child: Icon(
                  icon,
                  color: selected ? primary : Colors.grey,
                ),
              )),
          Text(
            label ?? '',
            style: TextStyle(
                color: selected ? primary : Colors.grey,
                fontSize: selected ? 14 : 12),
          ),
        ],
      ),
    );
  }
}
