import 'package:flutter/cupertino.dart';
import 'package:mpg_mobile/constants/route_names.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/business_valuation.dart';
import 'package:mpg_mobile/models/financtial_indicator.dart';
import 'package:mpg_mobile/models/loan.dart';
import 'package:mpg_mobile/models/non_financtial_indicator.dart';
import 'package:mpg_mobile/models/profit_statement.dart';
import 'package:mpg_mobile/models/user.dart';
import 'package:mpg_mobile/services/api/business_valuation_service.dart';
import 'package:mpg_mobile/services/authentication_service.dart';
import 'package:mpg_mobile/services/navigation_service.dart';
import 'package:mpg_mobile/services/ui/business_valuation/business_valuation_create_service.dart';
import 'package:stacked/stacked.dart';

class CreateValuationViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _businessValuationService = locator<BusinessValuationCreateService>();
  final _businessValuationApiService = locator<BusinessValuationApiService>();
  final _authenticationService = locator<AuthenticationService>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String errorMsg = '';

  TextEditingController _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;

  bool get addLoan => _businessValuationService.shouldAddLoan;

  onModelReady() {
    _nameController = _businessValuationService.nameController;
  }

  _showErrorMsg() {
    errorMsg = "Please fill the required fields";
    notifyListeners();
  }

  _isFormValid() {
    return formKey.currentState!.validate();
  }

  Future<void> onSubmit() async {
    bool isValid = _isFormValid();
    if (!isValid) {
      _showErrorMsg();
      return;
    }

    errorMsg = "";
    setBusy(true);
    String name = _nameController.text;
    List<FinanctialIndicator> financtialIndicators =
        _businessValuationService.getFinanctialIndicators();
    List<ProfitStatement> profitStatements =
        _businessValuationService.getProfitStatements();
    List<NonFinanctialIndicator> nonFinanctialIndicators =
        _businessValuationService.getNonFinanctialIndicators();
    Loan? loan = _businessValuationService.getLoan();

    double cogs = _businessValuationService.cogs;

    try {
      User? user = await _authenticationService.currentUser;
      BusinessValuation businessValuation = BusinessValuation(
        businessName: name,
        cogs: cogs,
        financtialIndicators: financtialIndicators,
        profitStatements: profitStatements,
        nonFinanctialIndicators: nonFinanctialIndicators,
        loan: loan,
        userId: user!.id,
      );

      await _businessValuationApiService.create(bv: businessValuation);
    } catch (e) {
      rethrow;
    }

    setBusy(false);
    _businessValuationService.dispose();
    _navigationService.navigateTo(businessValuationRoute);
  }

  toggleLoan() {
    _businessValuationService.shouldAddLoan =
        !_businessValuationService.shouldAddLoan;
    notifyListeners();
  }

  goBack() => _navigationService.popAndPushNamed(businessValuationRoute);

  onDispose() {}
}
