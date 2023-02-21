import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/router.dart';
import 'package:mpg_mobile/services/dialog_service.dart';
import 'package:mpg_mobile/services/navigation_service.dart';
import 'package:mpg_mobile/ui/views/startup_view.dart';
import 'package:url_strategy/url_strategy.dart';

import 'locator.dart';
import 'managers/dialog_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MPG',
      builder: (context, child) => Navigator(
        key: locator<DialogService>().dialogNavigationKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => DialogManager(child: child)),
      ),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: generateRoute,
      home: const StartUpView(),
    );
  }
}
