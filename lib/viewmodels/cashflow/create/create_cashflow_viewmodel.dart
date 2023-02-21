import 'package:flutter/cupertino.dart';
import 'package:mpg_mobile/constants/route_names.dart';
import 'package:mpg_mobile/constants/utils.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/cashflow.dart';
import 'package:mpg_mobile/models/http_error.dart';
import 'package:mpg_mobile/models/user.dart';
import 'package:mpg_mobile/services/api/cashflow_service.dart';
import 'package:mpg_mobile/services/authentication_service.dart';
import 'package:mpg_mobile/services/navigation_service.dart';
import 'package:mpg_mobile/services/ui/cashflow/cashflow_create_service.dart';
import 'package:stacked/stacked.dart';

class CreateCashFlowViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _cashFlowCreateService = locator<CashFlowCreateService>();
  final _authenticationService = locator<AuthenticationService>();
  final _cashflowApiService = locator<CashflowApiService>();

  TextEditingController get nameController =>
      _cashFlowCreateService.nameController;
  TextEditingController get checkingAccountController =>
      _cashFlowCreateService.checkingAccountController;
  TextEditingController get payrollAccountController =>
      _cashFlowCreateService.payrollAccountController;
  TextEditingController get savingsAccountController =>
      _cashFlowCreateService.savingsAccountController;
  TextEditingController get startDateController =>
      _cashFlowCreateService.startDateController;

  String errorMsg = '';

  setStartDate(DateTime? date) {
    if (date == null) return;
    startDateController.text = dateFormat.format(date);
    notifyListeners();
  }

  onModelReady() {}

  onDispose() {
    _cashFlowCreateService.dispose();
  }

  Future<void> onSubmit() async {
    errorMsg = '';
    setBusy(true);
    User? user = await _authenticationService.currentUser;
    try {
      CashFlow cashflow =
          _cashFlowCreateService.buildCashFlow(userId: user!.id!);
      await _cashflowApiService.create(cashflow: cashflow);
    } catch (e) {
      if (e is HttpError) {
        showError(e.message);
      } else {
        showError('Please, fill all the required fields');
      }
    }
    setBusy(false);
    _cashFlowCreateService.dispose();
    _navigationService.navigateTo(cashFlowRoute);
  }

  showError(String msg) {
    errorMsg = msg;
  }

  goBack() => _navigationService.popAndPushNamed(cashFlowRoute);
}
