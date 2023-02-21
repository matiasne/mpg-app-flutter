import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:mpg_mobile/constants/route_names.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/services/navigation_service.dart';
import 'package:stacked/stacked.dart';

class SignUpViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  int _currentStep = 0;
  int get currentStep => _currentStep;

  final List<String> _steps = ['Account', 'Subscription'];
  List<String> get steps => _steps;

  goHome() => _navigationService.navigateTo(homeViewRoute);

  void onStepTapped(int value) {
    _currentStep = value;
    notifyListeners();
  }
  
 
  void next() {
    if (_currentStep < _steps.length - 1) {
      _currentStep += 1;
    
      notifyListeners();
    }
  }

  void back() {
    if (_currentStep > 0) {
      _currentStep -= 1;
      notifyListeners();
    }
  }
}
