import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/client.dart';
import 'package:mpg_mobile/models/key_assumption.dart';
import 'package:mpg_mobile/models/objective.dart';
import 'package:mpg_mobile/models/scope.dart';
import 'package:mpg_mobile/services/download_abstract_service.dart';
import 'package:mpg_mobile/services/download_mobile_service.dart';
import 'package:mpg_mobile/services/api/project_service.dart';
import 'package:mpg_mobile/services/ui/cost_estimator/project_detail_service.dart';
import 'package:mpg_mobile/services/web_platform_service.dart';
import 'package:stacked/stacked.dart';

class ProposalDetailsViewModel extends BaseViewModel {
  final ProjectService _projectService = locator<ProjectService>();
  final ProjectDetailService _projectDetailService =
      locator<ProjectDetailService>();
  final WebPlatformService _webPlatformService = locator<WebPlatformService>();
  final MobilePlatformService _mobilePlatformService =
      locator<MobilePlatformService>();

  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;

  Client? get client => _projectDetailService.client;
  List<Objective>? get objectives => _projectDetailService.objectives;
  List<Scope>? get scopes => _projectDetailService.scopes;
  List<KeyAssumption>? get keyAssumptions =>
      _projectDetailService.keyAssumptions;
  DateTime? get startDate => _projectDetailService.startDate;
  DateTime? get endDate => _projectDetailService.endDate;
  double? get suggestedPrice => _projectDetailService.suggestedPrice;
  String? get creditTerms => _projectDetailService.creditTerms;

  TextEditingController _termsController = TextEditingController();
  TextEditingController get termsController => _termsController;
  bool _termsChanged = false;
  bool get termsChanged => _termsChanged;

  bool get isNotBusy => !isBusy;

  onModelReady() {
    _termsController =
        TextEditingController(text: _projectDetailService.creditTerms);
  }

  void onTermsChanged(String val) {
    _termsChanged = true;
    notifyListeners();
  }

  Future onSaveCreditTerms() async {
    int id = _projectDetailService.projectId!;
    setBusy(true);
    await _projectService.projectPatchById(
        id: id, creditTerms: _termsController.text);
    _projectDetailService.setCreditTerms(_termsController.text);
    _termsChanged = false;
    setBusy(false);
  }

  onDownload() async {
    int id = _projectDetailService.projectId!;
    double amount = _projectDetailService.suggestedPrice;
    DownloadService _downloadService =
        kIsWeb ? _webPlatformService : _mobilePlatformService;

    _isDownloading = true;
    notifyListeners();
    await _downloadService.downloadPdf(id: id, amount: amount);
    _isDownloading = false;
    notifyListeners();
  }

  onDispose() {
    _termsController.dispose();
  }
}
