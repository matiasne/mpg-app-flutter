import 'package:flutter/foundation.dart';
import 'package:mpg_mobile/services/api/cost_estimator_service.dart';
import 'package:universal_html/html.dart' as html;
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/services/download_abstract_service.dart';
import 'package:universal_html/html.dart';

class WebPlatformService implements DownloadService {
  final _costEstimatorService = locator<CostEstimatorService>();

  @override
  Future<void> downloadPdf({required int id, required double amount}) async {
    String url = _costEstimatorService
        .getDownloadProposalUrl(projectId: id, totalAmount: amount)
        .toString();
    html.window.open(url, "_blank");
  }

  String? getCurrentRoute() {
    Location location = html.window.location;
    String? route = location.pathname;
    var search = location.search;

    if(search == null){
      search = "";
    }
    if (route != null && location.search != null && kIsWeb) {
       
            route = route + search;
     
  
        
    }
    return route;
  }
}
