import 'package:flutter/foundation.dart';
import 'package:mpg_mobile/constants/enum/subscription_type_enum.dart';
import 'package:mpg_mobile/constants/route_names.dart';
import 'package:mpg_mobile/models/user.dart';
import 'package:mpg_mobile/services/authentication_service.dart';
import 'package:mpg_mobile/services/navigation_service.dart';
import 'package:mpg_mobile/services/web_platform_service.dart';
import 'package:stacked/stacked.dart';
import '../locator.dart';

class StartUpViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final WebPlatformService _webPlatformService = locator<WebPlatformService>();

  final onlyEsheetRoutes = [
    businessValuationRoute,
    createValuationRoute,
    businessValuationDetailRoute,
    cashFlowRoute,
    createCashFlowRoute,
    cashflowDetailRoute,
  ];

  bool _isPathAllowed(String path, String? subscription) {
    bool onlyForEsheets = onlyEsheetRoutes.contains(path);
    if (subscription == SubscriptionType.free && onlyForEsheets) {
      return false;
    }
    if (subscription == SubscriptionType.costEstimator && onlyForEsheets) {
      return false;
    }

    return true;
  }

  Future handleStartUpLogic() async {
    await _authenticationService.refreshUser();

    final User? user = await _authenticationService.currentUser;

    bool logged = user?.subscription?.type != SubscriptionType.free;

    if (logged) {
      if (kIsWeb) {
        String? path = _webPlatformService.getCurrentRoute();
        if (path != null && path != '/') {
          bool allowed = _isPathAllowed(path, user?.subscription?.type);
          if (allowed) {
            _navigationService.navigateTo(path);
          } else {
            _navigationService.navigateTo(homeViewRoute);
          }
        } else {
          _navigationService.navigateTo(logInViewRoute);
        }
      } else {
        _navigationService.navigateTo(logInViewRoute);
      }
      return;
    }

    _navigationService.navigateTo(logInViewRoute);
  }
}
