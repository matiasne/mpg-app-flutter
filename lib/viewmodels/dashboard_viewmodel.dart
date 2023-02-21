import 'package:mpg_mobile/constants/enum/subscription_type_enum.dart';
import 'package:mpg_mobile/constants/route_names.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/user.dart';
import 'package:mpg_mobile/services/authentication_service.dart';
import 'package:mpg_mobile/services/navigation_service.dart';
import 'package:stacked/stacked.dart';

class DashboardViewModel extends BaseViewModel {
  final _authenticationService = locator<AuthenticationService>();
  final _navigatorService = locator<NavigationService>();

  String _subscriptionType = SubscriptionType.free;
  String get subscriptionType => _subscriptionType;

  Future checkUser() async {
    setBusy(true);
    User? _currentUser = await _authenticationService.currentUser;
    if (_currentUser == null || _currentUser.subscription == null) {
      _navigatorService.navigateTo(homeViewRoute);
      setBusy(false);
      return;
    }

    _subscriptionType = _currentUser.subscription!.type;
    setBusy(false);
  }
}
