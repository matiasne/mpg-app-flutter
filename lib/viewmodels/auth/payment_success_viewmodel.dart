import 'package:mpg_mobile/constants/route_names.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/services/authentication_service.dart';
import 'package:mpg_mobile/services/navigation_service.dart';
import 'package:stacked/stacked.dart';

class PaymentSuccessViewModel extends BaseViewModel {

  final NavigationService _navigationService = locator<NavigationService>();
  final AuthenticationService _authenticationService= locator<AuthenticationService>();

  goDashboard() => _navigationService.navigateTo(dashboardViewRoute);

  refreshUser() => _authenticationService.refreshUser();
}