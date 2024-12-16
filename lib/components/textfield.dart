import 'package:flutter/material.dart';
import 'package:myapp/components/colors.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.leadingIcon,
      this.iconButton,
      this.trailingIcon,
      this.visible,
      this.maxLines,
      required this.hint,
      required this.error,
      this.onChanged});

  final IconData leadingIcon;
  final IconData? trailingIcon;
  final IconButton? iconButton;
  final bool? visible;
  final int? maxLines;
  final String hint;
  final String error;
  final TextEditingController controller;
  final void Function()? onChanged;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool visibility = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: 1000,
        child: TextFormField(
          controller: widget.controller,
          style: TextStyle(color: darkMode ? Colors.white : Colors.black87),
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primary)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primary)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primary)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primary)),
              hintStyle: TextStyle(color: Colors.grey.shade500),
              hintText: widget.hint,
              labelText: widget.hint,
              labelStyle:
                  TextStyle(color: darkMode ? Colors.white : Colors.black87),
              prefixIcon: Icon(widget.leadingIcon),
              prefixIconColor: primary,
              suffixIcon:

                  // se la scritta è visibile o meno
                  widget.visible == true
                      ? visibility
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  visibility = false;
                                });
                              },
                              icon: const Icon(Icons.visibility_off_rounded))
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  visibility = true;
                                });
                              },
                              icon: const Icon(Icons.visibility_rounded))

                      // se non esiste un'icona di chiusura
                      : widget.trailingIcon != null
                          ? Icon(widget.trailingIcon)
                          : null,
              suffixIconColor: Colors.grey.shade300),
          obscureText: widget.visible != null ? visibility : false,
          maxLines: widget.maxLines ?? 1,
          onChanged: (value) =>
              widget.onChanged != null ? widget.onChanged!() : null,
          validator: (value) =>
              value!.isEmpty && widget.hint != 'Note' ? widget.error : null,
        ),
      ),
    );
  }
}
