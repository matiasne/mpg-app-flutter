import 'package:flutter/services.dart';
import 'package:mpg_mobile/util/formatters.dart';

class NumericalRangeFormatter extends TextInputFormatter {
  final double min;
  final double max;

  NumericalRangeFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '') {
      return newValue;
    } else if (int.parse(newValue.text) < min) {
      return const TextEditingValue().copyWith(text: min.toStringAsFixed(2));
    } else {
      return int.parse(newValue.text) > max ? oldValue : newValue;
    }
  }
}

class PriceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newString = Formatters.toPrice(newValue.text);
    TextSelection selection =
        TextSelection.fromPosition(TextPosition(offset: newString.length));
    return newString == newValue.text
        ? newValue
        : TextEditingValue(text: newString, selection: selection);
  }
}
