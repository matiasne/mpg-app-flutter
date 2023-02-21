import 'package:http/http.dart' as http;
import 'package:mpg_mobile/constants/environments.dart';

class ApiRoutes {
  static const signUp = '/auth/sign-up';
  static const logIn = '/auth/log-in';
  static const costEstimator = '/cost-estimator';
  static const customer = '/customer';
  static const company = '/company';
  static const client = '/client';
  static const project = '/project';
  static const users = '/users';
  static const payments = '/payments';
  static const businessValuation = '/business-valuation';
  static const cashflow = '/cashflow';
}

class Endpoints {
  static const localhostAndroidEmulator = 'http://10.0.2.2:3000';
  static const localhostIosEmulator = 'http://localhost:3000';
  static const localhostWeb = 'http://localhost:3000';
  static const dev = 'https://mpg-server.herokuapp.com';
  static const uat = 'https://mpg-server-uat.herokuapp.com';
  static const prod = 'https://mpg-server-prod.herokuapp.com';
}

class Api {
  final Environments environment;
  final Map<String, String> headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  final client = http.Client();

  Api({required this.environment});

  String getEndpoint() {
    switch (environment) {
      case Environments.dev:
        return Endpoints.dev;
      case Environments.localAndroidEmulator:
        return Endpoints.localhostAndroidEmulator;
      case Environments.localIosEmulator:
        return Endpoints.localhostIosEmulator;
      case Environments.localWeb:
        return Endpoints.localhostWeb;
      case Environments.uat:
        return Endpoints.uat;
      case Environments.prod:
        return Endpoints.prod;
    }
  }
}
