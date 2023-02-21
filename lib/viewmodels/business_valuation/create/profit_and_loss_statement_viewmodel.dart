import 'package:flutter/material.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/services/ui/business_valuation/business_valuation_create_service.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:mpg_mobile/util/formatters.dart';
import 'package:stacked/stacked.dart';
import 'package:mpg_mobile/extensions/string_extensions.dart';

class ProfitAndLossStatementViewModel extends ReactiveViewModel {
  final _businessValuationCreateService =
      locator<BusinessValuationCreateService>();

  final List<DataColumn> _columns = const [
    DataColumn(label: Text('Metric')),
    DataColumn(label: Text('Current')),
    DataColumn(label: Text('Projected')),
  ];

  List<AppTableRow> _rows = [];

  List<AppTableRow> get rows => _rows;
  List<DataColumn> get columns => _columns;

  final _cogsController = TextEditingController(text: '0');
  TextEditingController get cogsController => _cogsController;

  Map<String, ProfitStatementMetric> metrics = {};

  onModelReady() => rebuildTable();

  rebuildTable() {
    _rows = [];
    _loadMetrics();
    _buildRevenueRow();
    _buildCOGSRow();
    _buildGrossProfitRow();
    _buildGeneralExpensesRow();
    _buildNetProfitRow();
    _businessValuationCreateService.setProfitStatementMetrics(metrics: metrics);
  }

  _loadMetrics() {
    metrics = {
      _Key.revenue: ProfitStatementMetric(
          current: 0.0,
          currentRate: 0.0,
          projected: 0.0,
          projectedRate: 0.0),
      _Key.cogs: ProfitStatementMetric(
          current: 0.0,
          currentRate: 0.0,
          projected: 0.0,
          projectedRate: 0.0),
      _Key.grossProfit: ProfitStatementMetric(
          current: 0.0,
          currentRate: 0.0,
          projected: 0.0,
          projectedRate: 0.0),
      _Key.generalExpenses: ProfitStatementMetric(
          current: 0.0,
          currentRate: 0.0,
          projected: 0.0,
          projectedRate: 0.0),
      _Key.netProfit: ProfitStatementMetric(
          current: 0.0,
          currentRate: 0.0,
          projected: 0.0,
          projectedRate: 0.0)
    };
  }

  _buildRevenueRow() {
    double revenue = _businessValuationCreateService.revenue;
    double revenueRate = revenue == 0 ? revenue : (revenue / revenue) * 100;
    double profit =
        revenue * (1 + _businessValuationCreateService.revenueGrowth / 100);
    double profitRate = profit == 0 ? profit : (profit / profit) * 100;

    if (metrics.containsKey(_Key.revenue)) {
      metrics[_Key.revenue]!.current = revenue;
      metrics[_Key.revenue]!.currentRate = revenueRate;
      metrics[_Key.revenue]!.projected = profit;
      metrics[_Key.revenue]!.projectedRate = profitRate;
    }

    List<DataCell> cells = [
      const DataCell(Text('Revenue')),
      DataCell(Text('\$${Formatters.toPrice(revenue.toStringAsFixed(2))} ($revenueRate%)')),
      DataCell(Text(
          '\$${Formatters.toPrice(profit.toStringAsFixed(2))} (${profitRate.toStringAsFixed(2)}%)')),
    ];
    AppTableRow row = AppTableRow(cells: cells);
    _rows.add(row);
  }

  _buildCOGSRow() {
    double cogs = _businessValuationCreateService.cogs;
    double revenue = _businessValuationCreateService.revenue;
    double cogsRate = revenue == 0 ? revenue : cogs / revenue * 100;

    double revenueProfit =
        revenue * (1 + _businessValuationCreateService.revenueGrowth / 100);
    double cogsProfit = revenueProfit * cogsRate / 100;

    if (metrics.containsKey(_Key.cogs)) {
      metrics[_Key.cogs]!.current = cogs;
      metrics[_Key.cogs]!.currentRate = cogsRate;
      metrics[_Key.cogs]!.projected = cogsProfit;
      metrics[_Key.cogs]!.projectedRate = cogsRate;
    }

    List<DataCell> cells = [
      const DataCell(Text('COGS')),
      DataCell(Text('\$${Formatters.toPrice(cogs.toStringAsFixed(2))} (${cogsRate.toStringAsFixed(2)}%)')),
      DataCell(Text(
          '\$${Formatters.toPrice(cogsProfit.toStringAsFixed(2))} (${cogsRate.toStringAsFixed(2)}%)')),
    ];
    AppTableRow row = AppTableRow(cells: cells);
    _rows.add(row);
  }

  _buildGrossProfitRow() {
    double revenue = _businessValuationCreateService.revenue;
    double cogs = _businessValuationCreateService.cogs;
    double grossProfit = revenue - cogs;
    double grossProfitRate =
        revenue == 0 ? revenue : grossProfit / revenue * 100;

    double revenueProfit =
        revenue * (1 + _businessValuationCreateService.revenueGrowth / 100);
    double cogsRate = revenue == 0 ? revenue : cogs / revenue * 100;
    double cogsProfit = revenueProfit * cogsRate / 100;
    double grossProfitRevenue = revenueProfit - cogsProfit;

    double grossProfitRevenueRate = revenueProfit == 0
        ? revenueProfit
        : grossProfitRevenue / revenueProfit * 100;

    if (metrics.containsKey(_Key.grossProfit)) {
      metrics[_Key.grossProfit]!.current = grossProfit;
      metrics[_Key.grossProfit]!.currentRate = grossProfitRate;
      metrics[_Key.grossProfit]!.projected = grossProfitRevenue;
      metrics[_Key.grossProfit]!.projectedRate = grossProfitRevenueRate;
    }

    List<DataCell> cells = [
      const DataCell(Text('Gross Profit')),
      DataCell(Text('\$${Formatters.toPrice(grossProfit.toStringAsFixed(2))} '
          '(${grossProfitRate.toStringAsFixed(2)}%)')),
      DataCell(Text('\$${Formatters.toPrice(grossProfitRevenue.toStringAsFixed(2))} '
          '(${grossProfitRevenueRate.toStringAsFixed(2)}%)')),
    ];
    AppTableRow row = AppTableRow(cells: cells);
    _rows.add(row);
  }

  _buildGeneralExpensesRow() {
    double revenue = _businessValuationCreateService.revenue;
    double cogs = _businessValuationCreateService.cogs;
    double netProfit = _businessValuationCreateService.ebitda;
    double grossProfit = revenue - cogs;
    double generalExpenses = grossProfit - netProfit;
    double revenueProfit =
        revenue * (1 + _businessValuationCreateService.revenueGrowth / 100);
    double generalExpensesRate =
        revenue == 0 ? revenue : generalExpenses / revenue * 100;

    double projectedGeneralExpenses = revenueProfit * generalExpensesRate / 100;

    if (metrics.containsKey(_Key.generalExpenses)) {
      metrics[_Key.generalExpenses]!.current = generalExpenses;
      metrics[_Key.generalExpenses]!.currentRate = generalExpensesRate;
      metrics[_Key.generalExpenses]!.projected = projectedGeneralExpenses;
      metrics[_Key.generalExpenses]!.projectedRate = generalExpensesRate;
    }

    List<DataCell> cells = [
      const DataCell(Text('General & Admin Expenses')),
      DataCell(Text('\$${Formatters.toPrice(generalExpenses.toStringAsFixed(2))}'
          ' (${generalExpensesRate.toStringAsFixed(2)}%)')),
      DataCell(Text('\$${Formatters.toPrice(projectedGeneralExpenses.toStringAsFixed(2))}'
          ' (${generalExpensesRate.toStringAsFixed(2)}%)')),
    ];
    AppTableRow row = AppTableRow(cells: cells);
    _rows.add(row);
  }

  _buildNetProfitRow() {
    double cogs = _businessValuationCreateService.cogs;
    double netProfit = _businessValuationCreateService.ebitda;
    double revenue = _businessValuationCreateService.revenue;

    double netProfitRate = revenue == 0 ? revenue : netProfit / revenue * 100;
    double revenueProfit =
        revenue * (1 + _businessValuationCreateService.revenueGrowth / 100);
    double cogsRate = revenue == 0 ? revenue : cogs / revenue * 100;
    double cogsProfit = revenueProfit * cogsRate / 100;
    double projectedGrossProfit = revenueProfit - cogsProfit;
    double grossProfit = revenue - cogs;
    double generalExpenses = grossProfit - netProfit;
    double generalExpensesRate =
        revenue == 0 ? revenue : generalExpenses / revenue * 100;
    double projectedGeneralExpenses = revenueProfit * generalExpensesRate / 100;
    double projectedNetProfit = projectedGrossProfit - projectedGeneralExpenses;

    if (metrics.containsKey(_Key.netProfit)) {
      metrics[_Key.netProfit]!.current = netProfit;
      metrics[_Key.netProfit]!.currentRate = netProfitRate;
      metrics[_Key.netProfit]!.projected = projectedNetProfit;
      metrics[_Key.netProfit]!.projectedRate = netProfitRate;
    }

    List<DataCell> cells = [
      const DataCell(Text('Net Profit')),
      DataCell(Text('\$${Formatters.toPrice(netProfit.toStringAsFixed(2))} (${netProfitRate.toStringAsFixed(2)}%)')),
      DataCell(Text('\$${Formatters.toPrice(projectedNetProfit.toStringAsFixed(2))} '
          '(${netProfitRate.toStringAsFixed(2)}%)')),
    ];
    AppTableRow row = AppTableRow(cells: cells);
    _rows.add(row);
  }

  onCOGSChanged(String? val) {
    if (val == null) return;
    _businessValuationCreateService.setCOGS(val.parseDouble());
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_businessValuationCreateService];

  @override
  void dispose() {
    _cogsController.dispose();
    super.dispose();
  }
}

class _Key {
  static String revenue = 'Revenue';
  static String cogs = 'COGS';
  static String grossProfit = 'Gross Profit';
  static String generalExpenses = 'General & Admin Expenses';
  static String netProfit = 'Net Profit';
}

class ProfitStatementMetric {
  double current;
  double currentRate;
  double projected;
  double projectedRate;

  ProfitStatementMetric(
      {required this.current,
      required this.currentRate,
      required this.projected,
      required this.projectedRate});
}
