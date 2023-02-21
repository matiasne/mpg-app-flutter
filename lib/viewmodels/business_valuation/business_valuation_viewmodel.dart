import 'package:mpg_mobile/constants/route_names.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/business_valuation.dart';
import 'package:mpg_mobile/models/user.dart';
import 'package:mpg_mobile/services/api/business_valuation_service.dart';
import 'package:mpg_mobile/services/authentication_service.dart';
import 'package:mpg_mobile/services/navigation_service.dart';
import 'package:mpg_mobile/ui/widgets/tool_description_banner.dart';
import 'package:stacked/stacked.dart';

class BusinessValuationViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authenticationService = locator<AuthenticationService>();
  final _businessValuationService = locator<BusinessValuationApiService>();

  String descriptionTitle = 'Business Valuation';
  List<DescriptionText> fullDescription = [
    DescriptionText(
        text:
            "\n\nBusiness valuation is the process of determining the economic value of a business, "
            "giving owners an objective estimate of the value of their company. BV might include "
            "analysis of the company's management, its capital structure, its future earnings "
            "prospects or the market value of its assets.  All business valuations are estimates. "
            "Typically, a business valuation happens when an owner is looking to sell all or a part of their business, "
            "or merge with another company.",
        isTitle: false),
    DescriptionText(text: 'Methodology', isTitle: true),
    DescriptionText(
        text: 'Step 1. Enter prior year revenue from Profit & Loss statement.'
            '\nStep 2. Enter project revenue growth percentage (%).'
            '\nStep 3.  Enter prior year Net Profit from Profit & Loss statement'
            '\nStep 4. Enter project Net Profit growth percentage (%)'
            '\nStep 5. Enter Cost of Goods Sold percentages (COGS %) from prior year Profit & Loss statement'
            '\nStep 6.  Enter Key Non-Financial Indicators for the business.',
        isTitle: false),
    DescriptionText(
        text: 'assets/content/business_valuation_description.png',
        isTitle: false,
        type: ContentType.image),
    DescriptionText(text: 'Reasons to value a business', isTitle: true),
    DescriptionText(
        text:
            '1.  Business Sales - When one is considering selling a business, a business valuation enables you to better understand the realistic value of your company'
            '\n2.  Partnership Matters - Shareholder buyouts are common in closely held businesses for several reasons including retirement, death, and divorce.'
            '\n3.  Estate & Gift tax - Business Valuation’s involves preparing valuations for estate and gift tax purposes'
            '\n4.  Buy-Sell - Many companies with two or more owners enter into legally binding buy-sell agreements'
            '\n5.  Divorce - Business Valuations are frequently engaged to provide support in family law and divorce disputes6.  Corporate Litigation - When involved with corporate litigation, it is prudent for the shareholders and counsel to engage the services'
            '\n7.  SBA Loans - When looking to borrow, or bring in an investor, a good valuation is necessary'
            '\n8.  There are many other reasons to obtain a business appraisal.',
        isTitle: false),
  ];

  String preview =
      "Business valuation is the process of determining the economic value of a business, "
      "giving owners an objective estimate of the value of their company. BV might include "
      "analysis of the company's management, its capital structure, its future earnings "
      "prospects or the market value of its assets.  All business valuations are estimates. "
      "Typically, a business valuation happens when an owner is looking to sell all or a part of their business, "
      "or merge with another company.";

  onCreateValuation() => _navigationService.navigateTo(createValuationRoute);

  Future<List<BusinessValuation>> loadValuations() async {
    User? user = await _authenticationService.currentUser;
    if (user != null) {
      int? userId = user.id!;
      return _businessValuationService.getAllByUserId(userId: userId);
    } else {
      _redirectHome();
      return [];
    }
  }

  _redirectHome() => _navigationService.navigateTo(homeViewRoute);
}
