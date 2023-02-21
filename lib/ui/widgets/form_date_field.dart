import 'package:flutter/material.dart';
import 'package:mpg_mobile/constants/utils.dart';

class AppDateField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final void Function(DateTime?) onChanged;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;
  const AppDateField(
      {Key? key,
      required this.controller,
      required this.onChanged,
      this.label = 'Date',
      this.autovalidateMode = AutovalidateMode.disabled,
      this.validator})
      : super(key: key);

  @override
  _AppDateFieldState createState() => _AppDateFieldState();
}

class _AppDateFieldState extends State<AppDateField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        autovalidateMode: widget.autovalidateMode,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            label: Text(widget.label),
            border: InputBorder.none,
            suffixIcon: const Icon(Icons.calendar_today),
            hoverColor: Colors.grey[200],
            labelStyle: TextStyle(color: Colors.grey[600])),
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());

          DateTime? date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100));

          if (date != null) {
            widget.controller.text = dateFormat.format(date);
            widget.onChanged(date);
            setState(() {});
          }
        },
      ),
    );
  }
}
