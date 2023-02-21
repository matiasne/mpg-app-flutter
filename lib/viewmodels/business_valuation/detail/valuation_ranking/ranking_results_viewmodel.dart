import 'package:flutter/material.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/services/ui/business_valuation/projections.service.dart';
import 'package:mpg_mobile/services/ui/business_valuation/ranking_service.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:mpg_mobile/util/formatters.dart';
import 'package:stacked/stacked.dart';

class RankingResultsViewModel extends ReactiveViewModel {
  final _projectionService = locator<ProjectionsService>();
  final _rankingService = locator<RankingService>();

  final List<DataColumn> _columns = const [
    DataColumn(label: Text('Metric')),
    DataColumn(label: Text('Revenue')),
    DataColumn(label: Text('EBITDA')),
    DataColumn(label: Text('Net Profit')),
  ];

  final List<AppTableRow> _rows = [];

  List<AppTableRow> get rows => _rows;
  List<DataColumn> get columns => _columns;

  double get averageEstimatedValue =>
      _rankingService.averageAdjustedEstimatedValue;

  List<AppTableRow> buildTable() {
    List<AppTableRow> rows = [];
    rows.add(_buildMultiplierRow());
    rows.add(_buildEstimatedValueRow());
    rows.add(_buildAdjustedMultiplierRow());
    rows.add(_buildAdjustedDiffRow());
    rows.add(_buildAdjustedEstimatedValueRow());
    return rows;
  }

  _buildMultiplierRow() {
    List<DataCell> cells = [
      const DataCell(Text('Multiplier')),
      DataCell(Text(_projectionService.revenueMultiplier.toStringAsFixed(2))),
      DataCell(Text(_projectionService.ebitdaMultiplier.toStringAsFixed(2))),
      DataCell(Text(_projectionService.netIncomeMultiplier.toStringAsFixed(2))),
    ];
    return AppTableRow(cells: cells);
  }

  _buildEstimatedValueRow() {
    List<DataCell> cells = [
      const DataCell(Text('Estimated Value')),
      DataCell(Text('\$' +
          Formatters.toPrice(
              _projectionService.revenueEstimatedValue.toStringAsFixed(2)))),
      DataCell(Text('\$' +
          Formatters.toPrice(
              _projectionService.ebitdaEstimatedValue.toStringAsFixed(2)))),
      DataCell(Text('\$' +
          Formatters.toPrice(
              _projectionService.netIncomeEstimatedValue.toStringAsFixed(2)))),
    ];
    return AppTableRow(cells: cells);
  }

  _buildAdjustedEstimatedValueRow() {
    double revenueAdjustedEstimatedValue =
        _rankingService.revenueAdjustedEstimatedValue;
    double ebitdaAdjustedEstimatedValue =
        _rankingService.ebitdaAdjustedEstimatedValue;
    double netIncomeAdjustedEstimatedValue =
        _rankingService.netIncomeAdjustedEstimatedValue;
    List<DataCell> cells = [
      const DataCell(Text('Adjusted Estimated Value')),
      DataCell(Text('\$' +
          Formatters.toPrice(
              revenueAdjustedEstimatedValue.toStringAsFixed(2)))),
      DataCell(Text('\$' +
          Formatters.toPrice(ebitdaAdjustedEstimatedValue.toStringAsFixed(2)))),
      DataCell(Text('\$' +
          Formatters.toPrice(
              netIncomeAdjustedEstimatedValue.toStringAsFixed(2)))),
    ];
    return AppTableRow(cells: cells);
  }

  _buildAdjustedMultiplierRow() {
    double revenueAdjustedMultiplier =
        _rankingService.revenueAdjustedMultiplier;
    double ebitdaAdjustedMultiplier = _rankingService.ebitdaAdjustedMultiplier;
    double netIncomeAdjustedMultiplier =
        _rankingService.netIncomeAdjustedMultiplier;
    List<DataCell> cells = [
      const DataCell(Text('Adjusted Multiplier')),
      DataCell(Text(revenueAdjustedMultiplier.toStringAsFixed(2))),
      DataCell(Text(ebitdaAdjustedMultiplier.toStringAsFixed(2))),
      DataCell(Text(netIncomeAdjustedMultiplier.toStringAsFixed(2))),
    ];
    return AppTableRow(cells: cells);
  }

  _buildAdjustedDiffRow() {
    double revenueAdjustedDifference = _rankingService.revenueAdjustedDiff;
    double ebitdaAdjustedDifference = _rankingService.ebitdaAdjustedDiff;
    double netIncomeAdjustedDifference = _rankingService.netIncomeAdjustedDiff;
    List<DataCell> cells = [
      const DataCell(Text('Adjusted Difference')),
      DataCell(Text('\$' +
          Formatters.toPrice(revenueAdjustedDifference.toStringAsFixed(2)))),
      DataCell(Text('\$' +
          Formatters.toPrice(ebitdaAdjustedDifference.toStringAsFixed(2)))),
      DataCell(Text('\$' +
          Formatters.toPrice(netIncomeAdjustedDifference.toStringAsFixed(2)))),
    ];
    return AppTableRow(cells: cells);
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_rankingService];
}
