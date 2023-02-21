import 'package:mpg_mobile/constants/route_names.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/services/navigation_service.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  toSignUp() {
    _navigationService.navigateTo(signUpViewRoute);
  }

  toLogIn() {
    _navigationService.navigateTo(logInViewRoute);
  }
}