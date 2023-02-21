import 'package:flutter/cupertino.dart';
import 'package:mpg_mobile/constants/enum/subscription_type_enum.dart';
import 'package:mpg_mobile/constants/route_names.dart';
import 'package:mpg_mobile/constants/utils.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/http_error.dart';
import 'package:mpg_mobile/models/user.dart';
import 'package:mpg_mobile/services/authentication_service.dart';
import 'package:mpg_mobile/services/dialog_service.dart';
import 'package:mpg_mobile/services/navigation_service.dart';
import 'package:mpg_mobile/ui/views/auth/forgot_password_view.dart';
import 'package:mpg_mobile/ui/views/auth/signup_subscription_view.dart';
import 'package:stacked/stacked.dart';

class LoginViewModel extends BaseViewModel {
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool hasErrors = false;
  String errorMessage = '';

  Future onSubmit() async {
    bool isValid = formKey.currentState!.validate();
    if (!isValid) return;

    hasErrors = false;
    setBusy(true);

    User user = User(
      email: emailController.text,
      password: passwordController.text,
    );
    try {
      User? result = await _authenticationService.logIn(user: user);
      setBusy(false);

      if (result?.subscription?.type != SubscriptionType.free) {
        _navigationService.navigateTo(dashboardViewRoute);
      } else {
        _dialogService.showDialog(
          title: 'Complete Subscription',
          content: SignupSubscriptionView(),
          buttonTitle: 'Cancel',
        );
      }
    } catch (e) {
      setBusy(false);
      if (e is HttpError) {
        showError(message: e.message);
      } else {
        showError(message: e.toString());
      }
    }
  }

  showError({required String message}) {
    hasErrors = true;
    errorMessage = message;
    notifyListeners();
  }

  onPasswordReset() {
    _dialogService.showDialog(
      title: 'Reset Password',
      content: const ForgotPasswordView(),
      showConfirmButton: false,
    );
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty || !emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }
  toSignUp(){
    _navigationService.navigateTo(signUpViewRoute);
  }
}
