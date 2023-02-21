import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/dialog_model.dart';
import 'package:mpg_mobile/services/dialog_service.dart';
import 'package:mpg_mobile/services/stripe_service.dart';
import 'package:stacked/stacked.dart';

import '../../services/api/payments_service.dart';

class SignupSubscriptionViewModel extends BaseViewModel {
  final _stripeService = locator<StripeService>();
  final _paymentsService = locator<PaymentsService>();
  final _dialogService = locator<DialogService>();

  String? checkoutUrlEsheets;
  String? checkoutUrlCostEstimator;

  onModelReady() {}

  String getNameByPlan({required Plan plan}) {
    switch (plan) {
      case Plan.costEstimator:
        {
          return 'Cost Estimator';
        }
      case Plan.sheetsForSmallBusiness:
        {
          return 'Esheets';
        }
    }
  }

  Future<void> goPremium({required Plan plan}) async {
    setBusy(true);
    String url = await _paymentsService.getCheckoutUrl(plan: plan);
    setBusy(false);
    DialogResponse response = await _dialogService.showConfirmationDialog(
        title: 'Confirm',
        description:
            'You are about to be redirected to the payment checkout for ${getNameByPlan(plan: plan)} plan',
        confirmationTitle: 'Confirm');
    if (response.confirmed != null && response.confirmed!) {
      await _stripeService.redirectToCheckout(url: url);
    }
  }
}
