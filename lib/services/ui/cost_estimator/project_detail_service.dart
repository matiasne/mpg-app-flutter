import 'package:mpg_mobile/models/client.dart';
import 'package:mpg_mobile/models/key_assumption.dart';
import 'package:mpg_mobile/models/labor_cost.dart';
import 'package:mpg_mobile/models/material_cost.dart';
import 'package:mpg_mobile/models/objective.dart';
import 'package:mpg_mobile/models/project.dart';
import 'package:mpg_mobile/models/scope.dart';
import 'package:mpg_mobile/models/weekly_hour.dart';
import 'package:stacked/stacked.dart';

class ProjectDetailService with ReactiveServiceMixin {
  ProjectDetailService() {
    listenToReactiveValues([_projectName]);
  }

  Project? _project;
  Project? get project => _project;
  Client? get client => _project?.client;
  final ReactiveValue<String?> _projectName = ReactiveValue<String?>(null);
  String? get projectName => _projectName.value;
  List<Objective>? get objectives => _project?.objectives;
  List<Scope>? get scopes => _project?.scopes;
  List<KeyAssumption>? get keyAssumptions => _project?.keyAssumptions;
  DateTime? get startDate => _project?.startDate;
  DateTime? get endDate => _project?.endDate;
  List<WeeklyHour>? get weeklyHours => _project?.weekHours;
  String? get creditTerms => _project?.creditTerms;

  int? get projectId => _project?.id;
  List<MaterialCost> get materialCosts => _project!.materialCosts;
  List<LaborCost> get laborCosts => _project!.laborCosts;
  double get taxRatio => _project!.taxRatio;
  double get fringeRate => _project!.fringeRate;

  double _totalLaborCost = 0.0;
  double _totalLaborHours = 0.0;
  double _totalLaborRate = 0.0;
  double _nonBillableLaborHours = 0.0;
  double _nonBillableLaborRate = 0.0;
  double get totalLaborCost => _totalLaborCost;
  double get totalLaborHours => _totalLaborHours;
  double get nonBillableLaborHours => _nonBillableLaborHours;
  double get nonBillableLaborRate => _nonBillableLaborRate;
  double get laborPercentOfSales =>
      _suggestedPrice != 0 ? _totalLaborCost / _suggestedPrice * 100 : 0;
  double get totalLaborBurden => _totalLaborCost * taxRatio / 100;
  double get totalLaborBurdenPercentOfSales =>
      _suggestedPrice != 0 ? totalLaborBurden / _suggestedPrice * 100 : 0;
  double get totalFringeRate => _totalLaborCost * fringeRate / 100;
  double get fringeRatePercentOfSales =>
      _suggestedPrice != 0 ? totalFringeRate / _suggestedPrice * 100 : 0;

  double _totalMaterialCost = 0.0;
  double get totalMaterialCost => _totalMaterialCost;
  double get materialPercentOfSales =>
      _suggestedPrice != 0 ? _totalMaterialCost / _suggestedPrice * 100 : 0;

  double _totalDirectCost = 0.0;
  double get totalDirectCost => _totalDirectCost;
  double get totalDirectCostPercentOfSales =>
      _suggestedPrice != 0 ? _totalDirectCost / _suggestedPrice * 100 : 0;

  double _overheadRatio = 0.0;
  double _overhead = 0.0;
  double get overheadRatio => _overheadRatio;
  double get overhead => _overhead;
  double get overheadPercentOfSales =>
      _suggestedPrice != 0 ? _overhead / _suggestedPrice * 100 : 0;

  double _contingencyRate = 0.0;
  double _contingency = 0.0;
  double get contingencyRate => _contingencyRate;
  double get contingency => _contingency;
  double get contingencyPercentOfSales =>
      _suggestedPrice != 0 ? _contingency / _suggestedPrice * 100 : 0;

  double _salesComission = 0.0;
  double _sales = 0.0;
  double get salesComission => _salesComission;
  double get sales => _sales;
  double get salesPercentOfSales =>
      _suggestedPrice != 0 ? _sales / _suggestedPrice * 100 : 0;

  double _totalBreakeven = 0.0;
  double get totalBreakeven => _totalBreakeven;
  double get breakevenPercentOfSales =>
      _suggestedPrice != 0 ? _totalBreakeven / _suggestedPrice * 100 : 0;

  double _suggestedPrice = 0.0;
  double _desiredProfitRate = 0.0;
  double _profitAmount = 0.0;
  double get suggestedPrice => _suggestedPrice;
  double get suggestedPricePercentOfSales => 100;
  double get desiredProfitRate => _desiredProfitRate;
  double get profitAmount => _profitAmount;
  double get profitPercentOfSales =>
      _suggestedPrice != 0 ? _profitAmount / _suggestedPrice * 100 : 0;

  double _pricePerHour = 0.0;
  double _hours = 0.0;
  double get hours => _hours;
  double get pricePerHour => _pricePerHour;

  double _pricePerSquareFoot = 0.0;
  double _squareFeet = 0.0;
  double get squareFeet => _squareFeet;
  double get pricePerSquareFoot => _pricePerSquareFoot;

  initialize({required Project? project}) {
    if (project == null) {
      throw Exception('Estimate sheet service must contain a project');
    }

    _project = project;
    _setProjectName(project.name);
    _computeMaterialMetrics();
    _computeLaborMetrics();
    _computeDirectCost();
    _computeOverheadRatio();
    _computeContingency();
    _computeSalesComission();
    _computeTotalBreakeven();
    _computeDesiredProfit();
    _computePricePerHour();
    _computePricePerSquareFoot();
  }

  _setProjectName(String? name) {
    _projectName.value = name;
  }

  _computeMaterialMetrics() {
    for (var mc in materialCosts) {
      _totalMaterialCost += (mc.price * mc.quantity);
    }
  }

  _computeLaborMetrics() {
    for (var lc in laborCosts) {
      _totalLaborHours += lc.hours;
      _totalLaborRate += lc.rate;
      _totalLaborCost += (lc.hours * lc.rate);
    }
    _nonBillableLaborHours = _totalLaborHours * 0.1;
    if (laborCosts.isNotEmpty) {
      _nonBillableLaborRate = _totalLaborRate / laborCosts.length;
      _totalLaborCost += _nonBillableLaborRate * _nonBillableLaborHours;
    }
  }

  _computeDirectCost() {
    _totalDirectCost = _totalLaborCost +
        _totalMaterialCost +
        totalLaborBurden +
        totalFringeRate;
  }

  _computeOverheadRatio() {
    if (_project?.client?.annualFixedExpenses != null &&
        _project?.client?.annualCostOfGoodsSold != null &&
        _project?.client?.annualCostOfGoodsSold != 0) {
      double annualFixedExpenses = _project!.client!.annualFixedExpenses!;
      double annualCostOfGoodsSold = _project!.client!.annualCostOfGoodsSold!;
      if (annualCostOfGoodsSold != 0) {
        _overheadRatio = annualFixedExpenses / annualCostOfGoodsSold * 100;
      }
      _overhead = (_overheadRatio / 100) * _totalDirectCost;
    }
  }

  _computeContingency() {
    _contingencyRate = _project!.contingencyRate;
    _contingency = _contingencyRate * _totalDirectCost / 100;
  }

  _computeSalesComission() {
    _salesComission = _project!.salesComission;
    double accumulatedTotal = _totalDirectCost + _overhead + _contingency;
    if (accumulatedTotal != 0) {
      _sales = _salesComission * accumulatedTotal / 100;
    }
  }

  _computeTotalBreakeven() {
    _totalBreakeven = _totalDirectCost + _overhead + _contingency + _sales;
  }

  _computeDesiredProfit() {
    _desiredProfitRate = _project!.desiredProfit;
    double percentDesiredProfit = _desiredProfitRate / 100;

    if (percentDesiredProfit != 1) {
      _suggestedPrice = _totalBreakeven / (1 - percentDesiredProfit);
      _profitAmount = _suggestedPrice - _totalBreakeven;
    }
  }

  _computePricePerHour() {
    _hours = _totalLaborHours;
    if (_totalLaborHours != 0) {
      _pricePerHour = _suggestedPrice / _totalLaborHours;
    }
  }

  _computePricePerSquareFoot() {
    _squareFeet = _project!.squareFeet;
    if (_squareFeet != 0) _pricePerSquareFoot = _suggestedPrice / _squareFeet;
  }

  chackInitialized() {
    if (_project == null) {
      throw Exception('Estimate sheet service not initialized');
    }
  }

  setCreditTerms(String text) {
    _project?.creditTerms = text;
  }

  dispose() {
    _totalMaterialCost = 0.0;
    _totalLaborCost = 0.0;
    _totalLaborHours = 0.0;
    _totalLaborRate = 0.0;
    _nonBillableLaborHours = 0.0;
    _nonBillableLaborRate = 0.0;
    _totalDirectCost = 0.0;
    _overheadRatio = 0.0;
    _overhead = 0.0;
    _contingencyRate = 0.0;
    _contingency = 0.0;
    _salesComission = 0.0;
    _sales = 0.0;
    _totalBreakeven = 0.0;
    _suggestedPrice = 0.0;
    _desiredProfitRate = 0.0;
    _profitAmount = 0.0;
    _pricePerHour = 0.0;
    _hours = 0.0;
    _pricePerSquareFoot = 0.0;
    _squareFeet = 0.0;
    _project = null;
  }
}
