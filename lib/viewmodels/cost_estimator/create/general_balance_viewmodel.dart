import 'package:flutter/material.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/services/ui/cost_estimator/cost_estinator_input_form.service.dart';
import 'package:stacked/stacked.dart';

class GeneralBalanceViewModel extends BaseViewModel {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _costEstimatorService = locator<CostEstimatorFormService>();

  String headerText =
      'Gather these Numbers from Your Profit & Loss Statement or Your Financial Plan';
  String helperTextRevenue = 'Enter Full Year Projected Sales Revenue';
  String helperTextCosts = 'Enter Full Year Projected Cost of Goods Sold';
  String helperTextFixedCosts =
      'Enter Full Year Projected Operating Expenses (G&A)';

  final String _defaultRatio = '0.00';

  TextEditingController get revenueController =>
      _costEstimatorService.revenueController;
  TextEditingController get costController =>
      _costEstimatorService.costController;
  TextEditingController get expensesController =>
      _costEstimatorService.expensesController;
  TextEditingController get ratioController =>
      _costEstimatorService.ratioController;

  double overheadRatio = 0.0;

  onRatioChanged() {
    if (costController.text == '' || expensesController.text == '') {
      _costEstimatorService.ratioController.text = _defaultRatio;
      return;
    }

    double cost = double.parse(costController.text);
    double expenses = double.parse(expensesController.text);

    if (cost == 0) {
      _costEstimatorService.ratioController.text = _defaultRatio;
      return;
    }

    double ratio = (expenses / cost) * 100;
    _costEstimatorService.ratioController.text = ratio.toStringAsFixed(2);
  }
}
