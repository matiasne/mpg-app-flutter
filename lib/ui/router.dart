import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mpg_mobile/constants/route_names.dart';
import 'package:mpg_mobile/models/routing_data.dart';
import 'package:mpg_mobile/ui/views/auth/password_reset_view.dart';
import 'package:mpg_mobile/ui/views/business_valuation/create/create_valuation_view.dart';
import 'package:mpg_mobile/ui/views/business_valuation/detail/business_valuation_detail_view.dart';
import 'package:mpg_mobile/ui/views/cashflow/create/create_cashflow_view.dart';
import 'package:mpg_mobile/ui/views/cashflow/detail/cashflow_detail_view.dart';
import 'package:mpg_mobile/ui/views/cost_estimator/details/project_detail_view.dart';
import 'package:mpg_mobile/ui/views/cost_estimator/create/input_form_view.dart';
import 'package:mpg_mobile/ui/views/dashboard_view.dart';
import 'package:mpg_mobile/ui/views/home_view.dart';
import 'package:mpg_mobile/ui/views/auth/login_view.dart';
import 'package:mpg_mobile/ui/views/auth/payment_success_view.dart';
import 'package:mpg_mobile/ui/views/auth/signup_view.dart';
import 'package:mpg_mobile/extensions/string_extensions.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  String? settingsName = settings.name;
  RoutingData routingData = settingsName!.getRoutingData;
  switch (routingData.route) {
    // main routes
    case homeViewRoute:
      return _getPageRoute(const HomeView(), settings);
    case dashboardViewRoute:
      return _getPageRoute(const DashboardView(), settings);

    // Cost estimator routes
    case costEstimatorRoute:
      {
        final subRoute = costEstimatorRoute.substring(
          dashboardViewRoute.length,
        );
        return _getPageRoute(DashboardView(childRoute: subRoute), settings);
      }
    case projectDetailRoute:
      {
        int? id;
        if (routingData['id'] != null) id = int.tryParse(routingData['id']);
        return _getPageRoute(ProjectDetailView(projectId: id), settings);
      }
    case createProjectRoute:
      {
        return _getPageRoute(const CostEstimatorInputForm(), settings);
      }

    // business valuation routes
    case businessValuationRoute:
      {
        final subRoute = businessValuationRoute.substring(
          dashboardViewRoute.length,
        );
        return _getPageRoute(DashboardView(childRoute: subRoute), settings);
      }
    case createValuationRoute:
      {
        return _getPageRoute(const CreateValuationView(), settings);
      }
    case businessValuationDetailRoute:
      {
        int? id;
        if (routingData['id'] != null) id = int.tryParse(routingData['id']);
        return _getPageRoute(
            BusinessValuationDetailView(businessValuationId: id), settings);
      }
    // cash flow routes
    case cashFlowRoute:
      {
        final subRoute = cashFlowRoute.substring(
          dashboardViewRoute.length,
        );
        return _getPageRoute(DashboardView(childRoute: subRoute), settings);
      }
    case createCashFlowRoute:
      {
        return _getPageRoute(const CreateCashFlowView(), settings);
      }
    case cashflowDetailRoute:
      {
        int? id;
        if (routingData['id'] != null) id = int.tryParse(routingData['id']);
        return _getPageRoute(CashflowDetailView(cashflowId: id), settings);
      }

    // authentication routes
    case signUpViewRoute:
      return _getPageRoute(const SignUpView(), settings);
    case logInViewRoute:
      return _getPageRoute(const LoginView(), settings);
    case passwordResetRoute:
      String? token = routingData['t'];
      return _getPageRoute(PasswordResetView(token: token), settings);

    // payment routes
    case paymentSuccessRoute:
      return _getPageRoute(const PaymentSuccessView(), settings);

    // defualt
    default:
      return _getPageRoute(const HomeView(), settings);
  }
}

PageRoute _getPageRoute(Widget child, RouteSettings settings) {
  return _FadeRoute(child: child, routeName: settings.name ?? '');
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  final String routeName;
  _FadeRoute({required this.child, required this.routeName})
      : super(
          settings: RouteSettings(name: routeName),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              child,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
