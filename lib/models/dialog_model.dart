import 'package:flutter/material.dart';
import 'package:mpg_mobile/models/recurring_income.dart';

class DialogRequest {
  final String title;
  final Widget content;
  final String buttonTitle;
  final String? cancelTitle;
  final bool showConfirmButton;

  DialogRequest(
      {required this.title,
      required this.content,
      required this.buttonTitle,
      this.cancelTitle,
      required this.showConfirmButton});
}

class DialogResponse {
  final String? fieldOne;
  final String? fieldTwo;
  final String? fieldThree;
  final String? fieldFour;
  final bool? confirmed;

  DialogResponse({
    this.fieldOne,
    this.fieldTwo,
    this.fieldThree,
    this.fieldFour,
    this.confirmed,
  });
}

class RecurringIncomeDialogResponse extends DialogResponse {
  final RecurringIncome? recurringIncome;
  // ignore: overridden_fields, annotate_overrides
  final bool? confirmed;

  RecurringIncomeDialogResponse({
    this.recurringIncome,
    this.confirmed,
  });
}
