import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/business_valuation.dart';
import 'package:mpg_mobile/models/profit_statement.dart';
import 'package:mpg_mobile/services/ui/business_valuation/projections.service.dart';
import 'package:mpg_mobile/services/ui/business_valuation/ranking_service.dart';

class ProfitLossService {
  final _rankingService = locator<RankingService>();
  final _projectionsService = locator<ProjectionsService>();

  BusinessValuation? _businessValuation;
  double _initialValuation = 0;
  double get initialValuation => _initialValuation;
  double _revisedValuation = 0;
  double get revisedValuation => _revisedValuation;

  double get difference => _revisedValuation - _initialValuation;

  final int _yearsToProject = 5;
  int get yearsToProject => _yearsToProject;

  List<double> _revenueRowData = [];
  List<double> get revenueRowData => _revenueRowData;

  List<double> _cogsRowData = [];
  List<double> get cogsRowData => _cogsRowData;

  List<double> _cogsRateRowData = [];
  List<double> get cogsRateRowData => _cogsRateRowData;

  List<double> _percentChangeRowData = [];
  List<double> get percentChangeRowData => _percentChangeRowData;

  List<double> _grossProfitRowData = [];
  List<double> get grossProfitRowData => _grossProfitRowData;

  List<double> _grossProfitRateRowData = [];
  List<double> get grossProfitRateRowData => _grossProfitRateRowData;

  List<double> _expensesRowData = [];
  List<double> get expensesRowData => _expensesRowData;

  List<double> _ebitdaRow = [];
  List<double> get ebitdaRow => _ebitdaRow;

  List<double> _ebitdaRateRow = [];
  List<double> get ebitdaRateRow => _ebitdaRateRow;

  List<double> _initialPaymentsRow = [];
  List<double> get initialPaymentsRow => _initialPaymentsRow;

  List<double> _equityPaymentsRow = [];
  List<double> get equityPaymentsRow => _equityPaymentsRow;

  List<double> _cumulativePaymentsRow = [];
  List<double> get cumulativePaymentsRow => _cumulativePaymentsRow;

  List<double> _netEarningRow = [];
  List<double> get netEarningRow => _netEarningRow;

  List<double> _netEarningRateRow = [];
  List<double> get netEarningRateRow => _netEarningRateRow;

  List<double> _cumulativeNetRow = [];
  List<double> get cumulativeNetRow => _cumulativeNetRow;

  List<double> _cumulativeNetRateRow = [];
  List<double> get cumulativeNetRateRow => _cumulativeNetRateRow;

  // auxiliar data
  double _initialExpenses = 0;
  setInitialExpenses(double val) => _initialExpenses = val;
  double _firstExpenses = 0;
  setFirstExpenses(double val) => _firstExpenses = val;

  initialize({required BusinessValuation businessValuation}) {
    _businessValuation = businessValuation;

    _initialValuation = _rankingService.averageAdjustedEstimatedValue;
    ProfitStatement expenses = _businessValuation!.profitStatements[3];
    setInitialExpenses(expenses.current);
    setFirstExpenses(expenses.projected);

    _setRowData();
  }

  updateTable({required double? val, required ValueChangedType? type}) {
    _setRowData(val: val, type: type);
  }

  switchProjectionType({required ProjectionType type}) {
    if (type == ProjectionType.projected) {
      updateTable(
          val: _rankingService.averageAdjustedEstimatedValue,
          type: ValueChangedType.initialValuation);
    }

    if (type == ProjectionType.revised) {
      updateTable(
          val: _revisedValuation, type: ValueChangedType.initialValuation);
    }
  }

  _setRowData({double? val, ValueChangedType? type}) {
    if (type == ValueChangedType.initialValuation) {
      _initialValuation = val!;
    }

    if (type == ValueChangedType.expensesFirst) {
      setInitialExpenses(val!);
    }

    if (type == ValueChangedType.expensesSecond) {
      setFirstExpenses(val!);
    }

    double cogsResult = _projectionsService.cogs;
    double initialCogsRate = _projectionsService.revenue == 0
        ? 100
        : (cogsResult / _projectionsService.revenue) * 100;
    double grossProfit = _projectionsService.revenue - cogsResult;
    double initialEbitda = grossProfit - _initialExpenses;
    double initialPayment = 0;
    double initialEquityPayment = 0;
    double initialcomulativePayment = initialPayment + initialEquityPayment;
    double cumulativePayment = 0.0;
    double initialNetEarning =
        initialEbitda - initialPayment - initialEquityPayment;
    double cumulativeNetValue = initialNetEarning;

    // initial value for rows
    _revenueRowData = [_projectionsService.revenue];
    _cogsRowData = [cogsResult];
    _cogsRateRowData = [initialCogsRate];
    _percentChangeRowData = [0];
    _grossProfitRowData = [grossProfit];
    _grossProfitRateRowData = _projectionsService.revenue != 0
        ? [(grossProfit / _projectionsService.revenue) * 100]
        : [0];
    _expensesRowData = [_initialExpenses];

    _ebitdaRow = [initialEbitda];
    _ebitdaRateRow = _projectionsService.revenue != 0
        ? [(_ebitdaRow[0] / _projectionsService.revenue) * 100]
        : [0];
    _initialPaymentsRow = [initialPayment];
    _equityPaymentsRow = [initialEquityPayment];
    _cumulativePaymentsRow = [initialcomulativePayment];
    _netEarningRow = [initialNetEarning];
    _netEarningRateRow = _projectionsService.revenue != 0
        ? [initialNetEarning / _projectionsService.revenue * 100]
        : [0];
    _cumulativeNetRow = [cumulativeNetValue];
    _cumulativeNetRateRow = [0];

    // fill rows with projections
    for (var i = 0; i < yearsToProject; i++) {
      _revenueRowData.add(
          _revenueRowData[i] * (1 + (_projectionsService.revenueGrowth / 100)));
      _cogsRateRowData.add(initialCogsRate);
      _cogsRowData.add(_revenueRowData[i + 1] * (initialCogsRate / 100));
      _percentChangeRowData.add(_cogsRowData[i] != 0
          ? (_cogsRowData[i + 1] / _cogsRowData[i] * 100) - 100
          : 0);

      _grossProfitRowData.add(_revenueRowData[i + 1] - _cogsRowData[i + 1]);
      _grossProfitRateRowData.add(_revenueRowData[i + 1] != 0
          ? (_grossProfitRowData[i + 1] / _revenueRowData[i + 1]) * 100
          : 0);

      if (i == 0) {
        _expensesRowData.add(_firstExpenses);
        _initialPaymentsRow.add(_initialValuation / yearsToProject);
        _equityPaymentsRow.add(0);
      } else {
        _expensesRowData.add(_expensesRowData[i] * 1.05);

        _initialPaymentsRow.add(0);
        _equityPaymentsRow.add(_initialValuation / yearsToProject);
      }

      _ebitdaRow.add(_grossProfitRowData[i + 1] - _expensesRowData[i + 1]);
      _ebitdaRateRow.add(_revenueRowData[i + 1] != 0
          ? _ebitdaRow[i + 1] / _revenueRowData[i + 1] * 100
          : 0);

      cumulativePayment +=
          _initialPaymentsRow[i + 1] + _equityPaymentsRow[i + 1];
      _cumulativePaymentsRow.add(cumulativePayment);

      _netEarningRow.add(_ebitdaRow[i + 1] -
          _initialPaymentsRow[i + 1] -
          _equityPaymentsRow[i + 1]);

      _netEarningRateRow.add(_revenueRowData[i + 1] != 0
          ? _netEarningRow[i + 1] / _revenueRowData[i + 1] * 100
          : 0);

      cumulativeNetValue += _netEarningRow[i + 1];
      _cumulativeNetRow.add(cumulativeNetValue);

      if (i == 2) {
        double cumulatedRevenue =
            revenueRowData[1] + revenueRowData[2] + revenueRowData[3];
        double cumulativeRate = cumulatedRevenue != 0
            ? cumulativeNetValue / cumulatedRevenue * 100
            : 0;
        _cumulativeNetRateRow.add(cumulativeRate);
      } else if (i == 4) {
        double cumulatedRevenue = revenueRowData[1] +
            revenueRowData[2] +
            revenueRowData[3] +
            revenueRowData[4] +
            revenueRowData[5];
        double cumulativeRate = cumulatedRevenue != 0
            ? cumulativeNetValue / cumulatedRevenue * 100
            : 0;
        _cumulativeNetRateRow.add(cumulativeRate);
      } else {
        _cumulativeNetRateRow.add(0);
      }
    }
    _revisedValuation = _initialValuation + _cumulativeNetRow[4];
  }
}

enum ValueChangedType {
  initialValuation,
  cogsFirst,
  expensesFirst,
  expensesSecond
}

enum ProjectionType {
  projected,
  revised,
}
