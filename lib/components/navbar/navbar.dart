import 'package:flutter/material.dart';
import 'package:morepass/components/colors.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key, required this.items});
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 80,
      decoration: BoxDecoration(
          color: darkMode ? Colors.white : Colors.grey.shade900,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      child: Row(
        children: [
          for (Widget item in items)
            Expanded(
              child: InkWell(
                child: item,
              ),
            ),
        ],
      ),
    );
  }
}
