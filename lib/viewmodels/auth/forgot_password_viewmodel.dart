import 'package:flutter/material.dart';
import 'package:mpg_mobile/constants/utils.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/http_error.dart';
import 'package:mpg_mobile/services/api/users_service.dart';
import 'package:stacked/stacked.dart';

class ForgotPasswordViewModel extends BaseViewModel {
  final _usersService = locator<UsersService>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  String errorMsg = '';
  String successMsg =
      'Email sent, please check your inbox and follow the steps to reset your password';
  bool success = false;

  onConfirm() async {
    if (!formKey.currentState!.validate()) return;
    errorMsg = '';
    success = false;
    setBusy(true);
    try {
      await _usersService.sendPasswordResetEmail(email: emailController.text);
      success = true;
    } catch (err) {
      if (err is HttpError) {
        errorMsg = err.message;
      }
    } finally {
      setBusy(false);
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty || !emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }
}
