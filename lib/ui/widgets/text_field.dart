import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final AutovalidateMode autovalidateMode;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool enabled;
  final int minLines;
  final int maxLines;
  final void Function(String)? onChanged;
  final List<String> autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;
  final Widget? suffix;

  const AppTextField(
      {Key? key,
      required this.label,
      this.autovalidateMode = AutovalidateMode.disabled,
      this.obscureText = false,
      this.keyboardType = TextInputType.text,
      this.controller,
      this.validator,
      this.onChanged,
      this.enabled = true,
      this.minLines = 1,
      this.maxLines = 1,
      this.autofillHints = const [],
      this.inputFormatters,
      this.prefix,
      this.suffix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: AutofillGroup(
        child: TextField(
          autofillHints: autofillHints,
          minLines: minLines,
          maxLines: maxLines,
          enabled: enabled,
          decoration: InputDecoration(
              prefix: prefix,
              suffix: suffix,
              filled: true,
              fillColor: Colors.grey[200],
              label: Text(label),
              border: InputBorder.none,
              hoverColor: Colors.grey[200],
              labelStyle: TextStyle(color: Colors.grey[600])),
          style: TextStyle(
            color: Colors.grey[700],
          ),
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
        ),
      ),
    );
  }
}
