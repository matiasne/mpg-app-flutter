import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/client.dart';
import 'package:mpg_mobile/services/ui/cost_estimator/project_detail_service.dart';
import 'package:stacked/stacked.dart';

class SummaryDetailsViewModel extends BaseViewModel {
  final _projectDetailService = locator<ProjectDetailService>();

  Client? _client;
  Client? get client => _client;

  String? _projectName;
  String? get projectName => _projectName;

  double _totalHours = 0.0;
  double get totalHours => _totalHours;

  double _laborCost = 0.0;
  double get laborCost => _laborCost;

  double _fringeAmount = 0.0;
  double get fringeAmount => _fringeAmount;

  double _materialCost = 0.0;
  double get materialCost => _materialCost;

  final double _subContractorCost = 0.0;
  double get subContractorCost => _subContractorCost;

  double _overhead = 0.0;
  double get overhead => _overhead;

  double _salesComission = 0.0;
  double get salesComission => _salesComission;

  double _profit = 0.0;
  double get profit => _profit;

  double _profitRate = 0.0;
  double get profitRate => _profitRate;

  double _suggestedPrice = 0.0;
  double get suggestedPrice => _suggestedPrice;

  double _percentOfSales = 0.0;
  double get percentOfSales => _percentOfSales;

  onModelReady() {
    _initializeVariables();
  }

  _initializeVariables() {
    _client = _projectDetailService.client;
    _projectName = _projectDetailService.projectName;
    _totalHours = _projectDetailService.totalLaborHours;
    _laborCost = _projectDetailService.totalLaborCost;
    _fringeAmount = _projectDetailService.totalFringeRate;
    _materialCost = _projectDetailService.totalMaterialCost;
    _overhead = _projectDetailService.overhead;
    _salesComission = _projectDetailService.sales;
    _profit = _projectDetailService.profitAmount;
    _profitRate = _projectDetailService.desiredProfitRate;
    _suggestedPrice = _projectDetailService.suggestedPrice;
    _percentOfSales = _projectDetailService.totalDirectCostPercentOfSales;
  }
}
