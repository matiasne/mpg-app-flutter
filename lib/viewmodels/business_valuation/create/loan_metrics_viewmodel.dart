import 'package:flutter/material.dart';
import 'package:mpg_mobile/constants/utils.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/services/ui/business_valuation/business_valuation_create_service.dart';
import 'package:stacked/stacked.dart';

class LoanMetricsViewModel extends BaseViewModel {
  final _businessValuationService = locator<BusinessValuationCreateService>();

  DateTime? _loanStartDate;
  DateTime? get loanStartDate => _loanStartDate;

  TextEditingController get yearsController => _businessValuationService.yearsController;
  TextEditingController get amountController => _businessValuationService.amountController;
  TextEditingController get downPaymentController => _businessValuationService.downPaymentController;
  TextEditingController get loanStartDateController => _businessValuationService.loanStartDateController;

  setLoanStartDate(DateTime? date) {
    if(date == null) return;
    _loanStartDate = date;
    loanStartDateController.text = dateFormat.format(date);
    _businessValuationService.setLoanStartDate(date);
    notifyListeners();
  } 
}