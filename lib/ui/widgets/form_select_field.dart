import 'package:flutter/material.dart';

class AppSelectOption {
  String label;
  int? value;
  AppSelectOption({required this.label, required this.value});
}

class AppFormSelectField extends StatelessWidget {
  final String label;
  final AutovalidateMode autovalidateMode;
  final TextEditingController? controller;
  final String? Function(int?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final List<AppSelectOption> items;
  final void Function(int?)? onChanged;
  final int? value;
  final GlobalKey<FormFieldState>? formKey;

  const AppFormSelectField(
      {Key? key,
      required this.label,
      required this.items,
      required this.onChanged,
      required this.value,
      this.autovalidateMode = AutovalidateMode.disabled,
      this.obscureText = false,
      this.keyboardType = TextInputType.text,
      this.controller,
      this.validator,
      this.formKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      child: DropdownButtonFormField(
        key: formKey,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            label: Text(label),
            border: InputBorder.none,
            hoverColor: Colors.grey[200],
            labelStyle: TextStyle(color: Colors.grey[600])),
        onChanged: onChanged,
        value: value,
        validator: validator,
        autovalidateMode: autovalidateMode,
        hint: Text(label),
        items: items.map((item) {
          return DropdownMenuItem(
            child: Text(item.label),
            value: item.value,
          );
        }).toList(),
      ),
    );
  }
}
