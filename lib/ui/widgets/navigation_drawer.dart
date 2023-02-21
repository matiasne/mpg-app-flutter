import 'package:flutter/material.dart';
import 'package:mpg_mobile/constants/enum/subscription_type_enum.dart';
import 'package:mpg_mobile/constants/route_names.dart';
import 'package:mpg_mobile/models/user.dart';
import 'package:mpg_mobile/services/authentication_service.dart';
import 'package:mpg_mobile/services/navigation_service.dart';

import '../../locator.dart';

class NavigationDrawerA extends StatefulWidget {
  const NavigationDrawerA({Key? key, required this.subscriptionType})
      : super(key: key);

  final String subscriptionType;

  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawerA> {
  @override
  Widget build(BuildContext context) {
    bool isCostEstimator =
        widget.subscriptionType == SubscriptionType.costEstimator;
    bool isEsheets = widget.subscriptionType == SubscriptionType.esheets;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const AppDrawerHeader(),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              locator<NavigationService>().navigateTo(dashboardViewRoute);
            },
          ),
          if (isCostEstimator || isEsheets)
            ListTile(
              title: const Text('Cost estimator'),
              onTap: () {
                locator<NavigationService>().navigateTo(costEstimatorRoute);
              },
            ),
          if (isEsheets)
            ListTile(
              title: const Text('Business Valuation'),
              onTap: () {
                locator<NavigationService>().navigateTo(businessValuationRoute);
              },
            ),
          if (isEsheets)
            ListTile(
              title: const Text('Cash Flow'),
              onTap: () {
                locator<NavigationService>().navigateTo(cashFlowRoute);
              },
            ),
          const Divider(),
          ListTile(
            title: const Text('Log out'),
            onTap: () {
              locator<AuthenticationService>().logOut();
              locator<NavigationService>().navigateTo(homeViewRoute);
            },
          ),
        ],
      ),
    );
  }
}

class AppDrawerHeader extends StatelessWidget {
  const AppDrawerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      child: FutureBuilder(
          future: locator<AuthenticationService>().currentUser,
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.data == null) return Container();

            final User? user = snapshot.data;

            return Column(
              children: [
                const Text(
                  'MPG',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  user!.email,
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  user.company!.name,
                  style: const TextStyle(color: Colors.white),
                ),
                _SubscriptionStatusBadge(
                  text: user.subscription!.type,
                )
              ],
            );
          }),
    );
  }
}

class _SubscriptionStatusBadge extends StatelessWidget {
  final String text;
  const _SubscriptionStatusBadge({Key? key, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
