import 'package:flutter/material.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/services/ui/cost_estimator/project_detail_service.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:stacked/stacked.dart';

class MetricsViewModel extends BaseViewModel {
  final _projectDetailService = locator<ProjectDetailService>();

  final List<DataColumn> _columns = const [
    DataColumn(
        label: Text(
      'Metric',
      style: TextStyle(fontWeight: FontWeight.bold),
    )),
    DataColumn(
        label: Text(
      'Amount',
      style: TextStyle(fontWeight: FontWeight.bold),
    )),
    DataColumn(
        label: Text(
      'Percent of sales',
      style: TextStyle(fontWeight: FontWeight.bold),
    )),
  ];

  final List<AppTableRow> _rows = [];

  List<DataColumn> get columns => _columns;
  List<AppTableRow> get rows => _rows;

  double _totalCost = 0.0;
  double _totalCostPercentOfSales = 0.0;

  double _overheadRatio = 0.0;
  double _overhead = 0.0;
  double _overheadPercentOfSales = 0.0;
  double _contingency = 0.0;
  double _contingencyRatio = 0.0;
  double _contingencyPercentOfSales = 0.0;

  double _sales = 0.0;
  double _salesComission = 0.0;
  double _salesPercentOfSales = 0.0;

  double _totalBreakeven = 0.0;
  double _totalBreakevenPercentOfSales = 0.0;

  double _desiredProfitRate = 0.0;
  double _profitAmount = 0.0;
  double _profitAmountPercentOfSales = 0.0;

  double _suggestedPrice = 0.0;
  double _suggestedPricePercentOfSales = 0.0;

  double _pricePerHour = 0.0;
  double _hours = 0.0;

  double _pricePerSquareFoot = 0.0;
  double _squareFeet = 0.0;

  onModelReady() {
    _initializeVariables();
    _buildTable();
  }

  _initializeVariables() {
    _totalCost = _projectDetailService.totalDirectCost;
    _totalCostPercentOfSales =
        _projectDetailService.totalDirectCostPercentOfSales;
    _overheadRatio = _projectDetailService.overheadRatio;
    _overhead = _projectDetailService.overhead;
    _overheadPercentOfSales = _projectDetailService.overheadPercentOfSales;
    _contingencyRatio = _projectDetailService.contingencyRate;
    _contingency = _projectDetailService.contingency;
    _contingencyPercentOfSales =
        _projectDetailService.contingencyPercentOfSales;
    _salesComission = _projectDetailService.salesComission;
    _sales = _projectDetailService.sales;
    _salesPercentOfSales = _projectDetailService.salesPercentOfSales;
    _totalBreakeven = _projectDetailService.totalBreakeven;
    _totalBreakevenPercentOfSales =
        _projectDetailService.breakevenPercentOfSales;
    _desiredProfitRate = _projectDetailService.desiredProfitRate;
    _profitAmountPercentOfSales = _projectDetailService.profitPercentOfSales;
    _profitAmount = _projectDetailService.profitAmount;
    _suggestedPrice = _projectDetailService.suggestedPrice;
    _suggestedPricePercentOfSales =
        _projectDetailService.suggestedPricePercentOfSales;
    _pricePerHour = _projectDetailService.pricePerHour;
    _pricePerSquareFoot = _projectDetailService.pricePerSquareFoot;
    _hours = _projectDetailService.hours;
    _squareFeet = _projectDetailService.squareFeet;
  }

  _buildTable() {
    _buildRow(
      metric: 'Total direct cost',
      amount: _totalCost.toStringAsFixed(2),
      sales: _totalCostPercentOfSales.toStringAsFixed(2),
    );
    _buildRow(
      metric: 'Overhead Ratio ($_overheadRatio)',
      amount: _overhead.toStringAsFixed(2),
      sales: _overheadPercentOfSales.toStringAsFixed(2),
    );
    _buildRow(
      metric: 'Contingency (${_contingencyRatio.toStringAsFixed(2)}%)',
      amount: _contingency.toStringAsFixed(2),
      sales: _contingencyPercentOfSales.toStringAsFixed(2),
    );
    _buildRow(
      metric: 'Sales Comission (${_salesComission.toStringAsFixed(2)}%)',
      amount: _sales.toStringAsFixed(2),
      sales: _salesPercentOfSales.toStringAsFixed(2),
    );
    _buildRow(
      metric: 'Total Breakeven',
      amount: _totalBreakeven.toStringAsFixed(2),
      sales: _totalBreakevenPercentOfSales.toStringAsFixed(2),
    );
    _buildRow(
      metric: 'Desired Profit (${_desiredProfitRate.toStringAsFixed(2)}%)',
      amount: _profitAmount.toStringAsFixed(2),
      sales: _profitAmountPercentOfSales.toStringAsFixed(2),
    );
    _buildRow(
      metric: 'Suggested Price',
      amount: _suggestedPrice.toStringAsFixed(2),
      sales: _suggestedPricePercentOfSales.toStringAsFixed(2),
    );
    _buildRow(
      metric: 'Price Per Hour (${_hours.toStringAsFixed(2)} hs.)',
      amount: _pricePerHour.toStringAsFixed(2),
    );
    _buildRow(
      metric:
          'Price Per Square Foot (${_squareFeet.toStringAsFixed(2)} sq. feet)',
      amount: _pricePerSquareFoot.toStringAsFixed(2),
    );
  }

  _buildRow({
    required String metric,
    required String amount,
    String? sales,
  }) {
    List<DataCell> cells = [
      DataCell(Text(metric)),
      DataCell(Text('\$' + amount)),
      DataCell(Text(sales != null ? sales + '%' : '')),
    ];
    AppTableRow row = AppTableRow(cells: cells);
    _rows.add(row);
  }
}
