import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

enum Plan { costEstimator, sheetsForSmallBusiness }

class StripeService {
  void _launchURL(String url) async {
    if (!await launch(url, forceSafariVC: true)) throw 'Could not launch $url';
  }

  Future<void> redirectToCheckout({required String url}) async {
    if (kIsWeb) {
      _launchURL(url);
    }
  }
}
