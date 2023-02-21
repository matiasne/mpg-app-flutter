import 'package:flutter/material.dart';
import 'package:mpg_mobile/constants/enum/subscription_type_enum.dart';
import 'package:mpg_mobile/constants/route_names.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/http_error.dart';
import 'package:mpg_mobile/models/user.dart';
import 'package:mpg_mobile/services/api/users_service.dart';
import 'package:mpg_mobile/services/authentication_service.dart';
import 'package:mpg_mobile/services/dialog_service.dart';
import 'package:mpg_mobile/services/navigation_service.dart';
import 'package:mpg_mobile/ui/views/auth/signup_subscription_view.dart';
import 'package:stacked/stacked.dart';

class PasswordResetViewModel extends BaseViewModel {
  final _usersService = locator<UsersService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _authenticationService = locator<AuthenticationService>();

  TextEditingController newPass = TextEditingController();
  TextEditingController repeatPass = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String errorMsg = '';
  User? _currentUser;

  onModelReady({required String? token}) {
    fetchUser(token: token);
  }

  fetchUser({required String? token}) async {
    setBusy(true);
    try {
      _currentUser = await _usersService.fetchUserByToken(token: token);
    } catch (e) {
      if (e is HttpError) {
        errorMsg = e.message;
      }
    } finally {
      setBusy(false);
    }
  }

  onSubmit() async {
    bool isValid = formKey.currentState!.validate();
    if (!isValid) return;
    setBusy(true);
    try {
      User newUser = User(
          id: _currentUser!.id,
          email: _currentUser!.email,
          password: newPass.text);
      User? resultReset = await _usersService.resetPassword(user: newUser);
      if (resultReset == null) {
        throw HttpError(
            statusCode: 400,
            message:
                'Something went wrong, please try sending the email again');
      }

      resultReset.password = newPass.text;
      User? result = await _authenticationService.logIn(user: resultReset);
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
      if (e is HttpError) {
        errorMsg = e.message;
      }
    } finally {
      setBusy(false);
    }
  }

  String? requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required field';
    }
    return null;
  }

  String? equalPassValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required field';
    }
    if (newPass.text != value) {
      return 'The passwords should match';
    }
    return null;
  }
}
