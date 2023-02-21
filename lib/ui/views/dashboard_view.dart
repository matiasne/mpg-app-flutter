import 'package:flutter/material.dart';
import 'package:mpg_mobile/constants/route_names.dart';
import 'package:mpg_mobile/ui/views/business_valuation/business_valuation_view.dart';
import 'package:mpg_mobile/ui/views/cashflow/cashflow_view.dart';
import 'package:mpg_mobile/ui/widgets/navigation_drawer.dart';
import 'package:mpg_mobile/viewmodels/dashboard_viewmodel.dart';
import 'package:stacked/stacked.dart';

import 'cost_estimator/cost_estimator_projects_view.dart';

class DashboardView extends StatelessWidget {
  final String childRoute;
  const DashboardView({Key? key, this.childRoute = ''}) : super(key: key);

  Widget getChildWidget(DashboardViewModel model) {
    var fullRoute = dashboardViewRoute + childRoute;
    switch (fullRoute) {
      case costEstimatorRoute:
        return const CostEstimatorProjectsView();
      case businessValuationRoute:
        return const BusinessValuationView();
      case cashFlowRoute:
        return const CashFlowView();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text('MPG Management'),
        ),
        drawer: NavigationDrawerA(
          subscriptionType: model.subscriptionType,
        ),
        body: getChildWidget(model),
      ),
      onModelReady: (model) => model.checkUser(),
      viewModelBuilder: () => DashboardViewModel(),
    );
  }
}
