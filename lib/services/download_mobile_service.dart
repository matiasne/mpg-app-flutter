import 'package:dio/dio.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/services/api/cost_estimator_service.dart';
import 'package:mpg_mobile/services/download_abstract_service.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MobilePlatformService implements DownloadService {
  final _costEstimatorService = locator<CostEstimatorService>();

  @override
  Future<void> downloadPdf({required int id, required double amount}) async {
    bool hasPermission = await _requestWritePermission();
    if (!hasPermission) return;

    Dio dio = Dio();
    var dir = await getApplicationDocumentsDirectory();
    String url = _costEstimatorService
        .getDownloadProposalUrl(projectId: id, totalAmount: amount)
        .toString();
    String fileName = 'proposal.pdf';
    await dio.download(url, "${dir.path}/$fileName");
    OpenFile.open("${dir.path}/$fileName", type: 'application/pdf');
  }

  _requestWritePermission() async {
    await [
      Permission.storage,
    ].request();
    return await Permission.storage.request().isGranted;
  }
}
