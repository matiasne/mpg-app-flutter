import 'package:mpg_mobile/models/pricing_plan.dart';
import 'package:mpg_mobile/services/stripe_service.dart';

class PricingPlans {
  static List<PricingPlan> plans = [
    PricingPlan(
      title: 'Cost estimation\ntool',
      description: 'Cost estimation tool for big projects',
      priceDescription: '\$389 USD / year',
      toolsIncluded: ['Cost Estimator'],
      plan: Plan.costEstimator,
    ),
    PricingPlan(
      title: 'E-sheets for small business',
      description:
          'A set of tools for performance measurement on small business including:',
      priceDescription: '\$599 USD / year',
      toolsIncluded: ['Cost Estimator', 'Business Valuation', 'Cashflow'],
      plan: Plan.sheetsForSmallBusiness,
    ),
  ];
}
