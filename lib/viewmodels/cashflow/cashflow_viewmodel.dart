import 'package:mpg_mobile/constants/route_names.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/cashflow.dart';
import 'package:mpg_mobile/models/user.dart';
import 'package:mpg_mobile/services/api/cashflow_service.dart';
import 'package:mpg_mobile/services/authentication_service.dart';
import 'package:mpg_mobile/services/navigation_service.dart';
import 'package:mpg_mobile/ui/widgets/tool_description_banner.dart';
import 'package:stacked/stacked.dart';

class CashFlowViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authenticationService = locator<AuthenticationService>();
  final _cashflowApiService = locator<CashflowApiService>();

  String bannerTitle = 'Cashflow Forecasting Tool';
  String bannerPreview =
      'The goal of cash flow forecasting is to determine deficiencies or '
      'excesses in cash flow that may occur in your business during the periods for which '
      'the projection is prepared.';
  List<DescriptionText> bannerDescription = [
    DescriptionText(
        text:
            '\n\nThe goal of cash flow forecasting is to determine deficiencies or '
            'excesses in cash flow that may occur in your business during the periods for which '
            'the projection is prepared.',
        isTitle: false),
    DescriptionText(
        text:
            'Whenever cash flow deficiencies are revealed, your financial plans must be altered '
            'until a proper cash balance is attained.',
        isTitle: false),
    DescriptionText(
        text:
            'The cash flow management system put in place is one of the most detailed and '
            'comprehensive control systems that can be found in any small business.',
        isTitle: false),
    DescriptionText(
        text:
            'This Application is carefully managed by the bookkeeper of the company and '
            'reviewed on almost a daily basis by the owner. It starts with the current cash '
            'balance, projects out the receivables coming in on a weekly basis and then lists all '
            'the recurring expenses, debt payments and payables. This system allows you to '
            'maintain a positive cash balance at all times while still making all payments on a '
            'timely basis to take advantage of vendor discounts.',
        isTitle: false),
    DescriptionText(
        text:
            'CASH FLOW FORECASTING AND ANALYSIS, IS THIS REALLY NECESSARY? YES!!!',
        isTitle: true),
    DescriptionText(
        text:
            'If you project a positive cash position, you must analyze why you are in such a '
            'fortunate state before you spend the excess cash. Some questions to '
            'consider are:',
        isTitle: false),
    DescriptionText(
        text:
            '- Is your company at the top of a business cycle (e.g., Christmas for '
            'a retailer)?'
            '\n\n- Are you current on all of your debts?'
            '\n\n- Have you paid your taxes, including estimated taxes?',
        isTitle: false),
    DescriptionText(
        text: 'Unfortunately, lenders tend to loan money to '
            'companies that don’t need money over those that '
            'really need a loan. They also tend to charge higher '
            'interest rates to their customers that marginally '
            'qualify. Therefore, accurate cash flow forecasting is '
            'imperative to predict when moneys will be needed to '
            'enhance your ability to obtain a loan and to obtain the '
            'lowest interest rate possible.',
        isTitle: false)
  ];

  Future<List<CashFlow>> loadCashFlows() async {
    User? user = await _authenticationService.currentUser;
    if (user != null) {
      int? userId = user.id!;
      return _cashflowApiService.getAllByUserId(userId: userId);
    } else {
      _redirectHome();
      return [];
    }
  }

  _redirectHome() => _navigationService.navigateTo(homeViewRoute);

  onCreateCashFlow() => _navigationService.navigateTo(createCashFlowRoute);
}
