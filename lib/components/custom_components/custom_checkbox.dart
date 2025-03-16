import 'package:flutter/material.dart';
import 'package:morepass/components/colors.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({super.key, required this.child, required this.selected, this.onChanged});

  final Widget child;
  final bool selected;
  final void Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      hoverDuration: const Duration(milliseconds: 200),
      hoverColor: darkMode ? secondaryDark.withAlpha(255) : secondaryLight.withAlpha(255),
      onTap: () => onChanged!(!selected),
      child: Row(
        children: [
          child,
          Spacer(),
          Checkbox(
            value: selected,
            onChanged: onChanged,
            fillColor: WidgetStatePropertyAll(selected ? primary : Colors.transparent),
          )
        ],
      ),
    );
  }
}
