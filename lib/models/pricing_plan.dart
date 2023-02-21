import 'package:mpg_mobile/services/stripe_service.dart';

class PricingPlan {
  String title;
  String description;
  String priceDescription;
  Plan plan;
  List<String> toolsIncluded;

  PricingPlan({
    required this.title,
    required this.description,
    required this.priceDescription,
    required this.plan,
    required this.toolsIncluded,
  });
}
