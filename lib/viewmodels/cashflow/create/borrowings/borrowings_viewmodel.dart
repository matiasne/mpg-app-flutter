import 'package:flutter/cupertino.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/services/ui/cashflow/cashflow_create_service.dart';
import 'package:stacked/stacked.dart';

class BorrowingsViewModel extends BaseViewModel {
  final _cashflowCreateService = locator<CashFlowCreateService>();

  TextEditingController get savingsController =>
      _cashflowCreateService.savingsController;
  TextEditingController get locsController =>
      _cashflowCreateService.locsController;
  TextEditingController get outstandingDrawsController =>
      _cashflowCreateService.outstandingDrawsController;
  TextEditingController get otherSavingsController =>
      _cashflowCreateService.otherSavingsController;
}
