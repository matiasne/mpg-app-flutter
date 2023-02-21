import 'package:flutter/material.dart';
import 'package:mpg_mobile/constants/utils.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/company.dart';
import 'package:mpg_mobile/models/user.dart';
import 'package:mpg_mobile/services/authentication_service.dart';
import 'package:stacked/stacked.dart';
import 'package:mpg_mobile/constants/route_names.dart';

import '../../services/navigation_service.dart';

class SignupFormViewModel extends BaseViewModel {
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController contactNameController = TextEditingController();
  TextEditingController contactTitleController = TextEditingController();
  TextEditingController contactAddressController = TextEditingController();
  TextEditingController cityStateController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  bool hasErrors = false;
  String errorMessage = '';

  

  Future onSubmit() async {
    bool isValid = formKey.currentState!.validate();
    if (!isValid) {
      hasErrors = true;
      return;
    }

    hasErrors = false;
    setBusy(true);

    User user = getUser();
    try {
      await _authenticationService.signUp(user: user);
    } catch (e) {
      showError(message: e.toString());
      hasErrors = true;
    }
    setBusy(false);
  }

  showError({required String message}) {
    hasErrors = true;
    errorMessage = message;
    notifyListeners();
  }


  getUser() {
    Company company = Company(
        name: nameController.text,
        contactName: contactNameController.text,
        contactTitle: contactTitleController.text,
        businessAddress: contactAddressController.text,
        cityState: cityStateController.text,
        zipCode: zipCodeController.text,
        phoneNumber: phoneNumberController.text);

    return User(
        email: emailController.text,
        password: passwordController.text,
        company: company);
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty || !emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty || value.length < 6) {
      return 'Password must have at least 6 characters';
    }
    return null;
  }

  String? required(String? value) {
    if (value == null || value.isEmpty) {
      return 'The field is required';
    }
    return null;
  }
   toLogIn(){
  _navigationService.navigateTo(logInViewRoute);
  }
}
