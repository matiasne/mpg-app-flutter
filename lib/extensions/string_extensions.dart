import 'package:mpg_mobile/models/routing_data.dart';

extension StringExtension on String {
  RoutingData get getRoutingData {
    var uriData = Uri.parse(this);
    return RoutingData(
      queryParameters: uriData.queryParameters,
      route: uriData.path,
    );
  }

  double parseDouble() {
    String cleanString = replaceAll(",", "");
    return double.tryParse(cleanString) ?? 0;
  }
}
