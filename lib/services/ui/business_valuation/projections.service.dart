import 'package:mpg_mobile/models/business_valuation.dart';
import 'package:mpg_mobile/models/financtial_indicator.dart';
import 'package:stacked/stacked.dart';

class ProjectionsService with ReactiveServiceMixin {
  BusinessValuation? _businessValuation;

  List<FinanctialIndicator>? get financtialIndicators =>
      _businessValuation?.financtialIndicators;

  double _revenue = 0;
  double _revenueGrowth = 0;
  double _ebitda = 0;
  double _ebitdaGrowth = 0;
  double _netIncome = 0;
  double _netIncomeGrowth = 0;
  double _cogs = 0;

  final _tableData = ReactiveValue<List<RowData>>([]);
  List<RowData> get tableData => _tableData.value;

  double get revenue => _revenue;
  double get revenueGrowth => _revenueGrowth;
  double get ebitda => _ebitda;
  double get ebitdaGrowth => _ebitdaGrowth;
  double get netIncome => _netIncome;
  double get netIncomeGrowth => _netIncomeGrowth;
  double get cogs => _cogs;

  double _averageEstimatedValue = 0;
  double get averageEstimatedValue => _averageEstimatedValue;

  double _averageEstimatedValueWithNetIncome = 0;
  double get averageEstimatedValueWithNetIncome =>
      _averageEstimatedValueWithNetIncome;

  double _totalRevenue = 0;
  double get totalRevenue => _totalRevenue;
  double _totalEbtda = 0;
  double get totalEbtda => _totalEbtda;
  double _totalNetIncome = 0;
  double get totalNetIncome => _totalNetIncome;

  double _totalProjectedRevenue = 0;
  double get totalProjectedRevenue => _totalProjectedRevenue;
  double _totalProjectedEbtda = 0;
  double get totalProjectedEbtda => _totalProjectedEbtda;
  double _totalProjectedNetIncome = 0;
  double get totalProjectedNetIncome => _totalProjectedNetIncome;

  double get revenueProjectedAverage =>
      tableData.isEmpty ? 0 : _totalProjectedRevenue / tableData.length;
  double get ebitdaProjectedAverage =>
      tableData.isEmpty ? 0 : _totalProjectedEbtda / tableData.length;
  double get netIncomeProjectedAverage =>
      tableData.isEmpty ? 0 : _totalProjectedNetIncome / tableData.length;

  double _revenueMultiplier = 0;
  double get revenueMultiplier => _revenueMultiplier;
  double _ebitdaMultiplier = 0;
  double get ebitdaMultiplier => _ebitdaMultiplier;
  double _netIncomeMultiplier = 0;
  double get netIncomeMultiplier => _netIncomeMultiplier;

  double _revenueEstimatedValue = 0;
  double get revenueEstimatedValue => _revenueEstimatedValue;
  double _ebitdaEstimatedValue = 0;
  double get ebitdaEstimatedValue => _ebitdaEstimatedValue;
  double _netIncomeEstimatedValue = 0;
  double get netIncomeEstimatedValue => _netIncomeEstimatedValue;

  int _yearsToProject = 5;
  int get yearsToProject => _yearsToProject;

  setYearsToProject({required int years}) {
    _yearsToProject = years;
    _resetTableData();
  }

  ProjectionsService() {
    listenToReactiveValues([_tableData]);
  }

  setRevenue(String val) {
    _revenue = double.parse(val);
    _resetTableData();
  }

  setRevenueGrowth(String val) {
    _revenueGrowth = double.parse(val);
    _resetTableData();
  }

  setEBITDA(String val) {
    _ebitda = double.parse(val);
    _resetTableData();
  }

  setEBITDAGrowth(String val) {
    _ebitdaGrowth = double.parse(val);
    _resetTableData();
  }

  setNetIncome(String val) {
    _netIncome = double.parse(val);
    _resetTableData();
  }

  setNetIncomeGrowth(String val) {
    _netIncomeGrowth = double.parse(val);
    _resetTableData();
  }

  setCogs(String val) {
    _cogs = double.parse(val);
  }

  initialize({required BusinessValuation businessValuation}) {
    _businessValuation = businessValuation;
    _initializeVariables();
    _buildProjections();
    _setProjectionVariables();
  }

  _resetTableData() {
    _buildProjections();
    _setProjectionVariables();
  }

  _initializeVariables() {
    if (_businessValuation == null) return;
    _revenue = _businessValuation!.financtialIndicators.first.amount;
    _revenueGrowth =
        _businessValuation!.financtialIndicators.first.projectedGrowth;
    _ebitda = _businessValuation!.financtialIndicators[1].amount;
    _ebitdaGrowth = _businessValuation!.financtialIndicators[1].projectedGrowth;
    _netIncome = _businessValuation!.financtialIndicators.last.amount;
    _netIncomeGrowth =
        _businessValuation!.financtialIndicators.last.projectedGrowth;
    _cogs = _businessValuation!.cogs;
  }

  _buildProjections() {
    int currentYear = financtialIndicators!.first.year;

    RowData firstRow = RowData(
      year: currentYear,
      revenueValue: revenue,
      revenueGrowth: revenueGrowth,
      ebitdaValue: ebitda,
      ebitdaGrowth: ebitdaGrowth,
      netIncomeValue: netIncome,
      netIncomeGrowth: netIncomeGrowth,
    );

    List<RowData> tableData = [firstRow];

    RowData previousRow = firstRow;
    for (var i = 0; i < _yearsToProject; i++) {
      previousRow = _buildNextRow(previous: previousRow);
      tableData.add(previousRow);
    }

    _tableData.value = tableData;
  }

  _buildNextRow({required RowData previous}) {
    return RowData(
      year: previous.year + 1,
      revenueValue:
          previous.revenueValue * (1 + (previous.revenueGrowth / 100)),
      revenueGrowth: previous.revenueGrowth,
      ebitdaValue: previous.ebitdaValue * (1 + (previous.ebitdaGrowth / 100)),
      ebitdaGrowth: previous.ebitdaGrowth,
      netIncomeValue:
          previous.netIncomeValue * (1 + (previous.netIncomeGrowth / 100)),
      netIncomeGrowth: previous.netIncomeGrowth,
    );
  }

  _setProjectionVariables() {
    _totalRevenue = 0;
    _totalEbtda = 0;
    _totalNetIncome = 0;
    _totalProjectedRevenue = 0;
    _totalProjectedEbtda = 0;
    _totalProjectedNetIncome = 0;

    for (var rd in tableData) {
      _totalRevenue += rd.revenueValue;
      _totalEbtda += rd.ebitdaValue;
      _totalNetIncome += rd.netIncomeValue;

      if (rd.year != DateTime.now().year) {
        _totalProjectedRevenue += rd.revenueValue;
        _totalProjectedEbtda += rd.ebitdaValue;
        _totalProjectedNetIncome += rd.netIncomeValue;
      }
    }

    _revenueMultiplier = tableData.first.revenueValue != 0
        ? revenueProjectedAverage / tableData.first.revenueValue
        : 0;
    _ebitdaMultiplier = tableData.first.ebitdaValue != 0
        ? ebitdaProjectedAverage / tableData.first.ebitdaValue
        : 0;
    _netIncomeMultiplier = tableData.first.netIncomeValue != 0
        ? netIncomeProjectedAverage / tableData.first.netIncomeValue
        : 0;

    _revenueEstimatedValue = tableData.first.revenueValue * _revenueMultiplier;
    _ebitdaEstimatedValue = tableData.first.ebitdaValue * _ebitdaMultiplier;
    _netIncomeEstimatedValue =
        tableData.first.netIncomeValue * _netIncomeMultiplier;

    _averageEstimatedValue =
        averageNotZero([revenueEstimatedValue, ebitdaEstimatedValue]);
    _averageEstimatedValueWithNetIncome = averageNotZero(
        [revenueEstimatedValue, ebitdaEstimatedValue, netIncomeEstimatedValue]);
  }

  averageNotZero(List<num> values) {
    double total = 0;
    int count = 0;
    for (var val in values) {
      if (val != 0) count++;
      total += val;
    }
    return total / count;
  }
}

class RowData {
  int year;
  double revenueValue;
  double revenueGrowth;
  double ebitdaValue;
  double ebitdaGrowth;
  double netIncomeValue;
  double netIncomeGrowth;
  RowData({
    required this.year,
    required this.revenueValue,
    required this.revenueGrowth,
    required this.ebitdaValue,
    required this.ebitdaGrowth,
    required this.netIncomeValue,
    required this.netIncomeGrowth,
  });
}
