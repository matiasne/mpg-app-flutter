import 'package:intl/intl.dart';

RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
RegExp doubleRegex = RegExp(r'^[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)$');
RegExp priceRegex = RegExp(r'^((\d{1,3}|\s*){1})((\,\d{3}|\d)*)(\s*|\.(\d{0,2}))$');
RegExp intRegex = RegExp(r'(\d+)');
DateFormat dateFormat = DateFormat('MM/dd/yyyy');