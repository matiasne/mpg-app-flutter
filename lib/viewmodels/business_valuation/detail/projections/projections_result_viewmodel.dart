import 'package:flutter/material.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/services/ui/business_valuation/projections.service.dart';
import 'package:mpg_mobile/ui/widgets/form_select_field.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:mpg_mobile/util/formatters.dart';
import 'package:stacked/stacked.dart';

class ProjectionResultsViewModel extends ReactiveViewModel {
  final _projectionService = locator<ProjectionsService>();

  double get averageEstimatedValue => _projectionService.averageEstimatedValue;
  double get averageEstimatedValueWithNetIncome =>
      _projectionService.averageEstimatedValueWithNetIncome;

  final List<DataColumn> _columns = const [
    DataColumn(label: Text('YEAR')),
    DataColumn(label: Text('REVENUE')),
    DataColumn(label: Text('EBITDA')),
    DataColumn(label: Text('NET INCOME')),
  ];

  List<DataColumn> get columns => _columns;

  List<AppSelectOption> get years => [
        AppSelectOption(label: '3', value: 3),
        AppSelectOption(label: '4', value: 4),
        AppSelectOption(label: '5', value: 5),
        AppSelectOption(label: '6', value: 6),
        AppSelectOption(label: '7', value: 7),
        AppSelectOption(label: '8', value: 8),
        AppSelectOption(label: '9', value: 9),
        AppSelectOption(label: '10', value: 10),
      ];
  int get yearsToProject => _projectionService.yearsToProject;

  onModelReady() {}

  buildTable() {
    List<AppTableRow> _rows = [];

    for (var rd in _projectionService.tableData) {
      _rows.add(_buildRow(data: rd));
    }

    _rows.add(_buildEmptyRow());

    int count = _projectionService.tableData.length;

    _rows.addAll([
      _buildStat(
          name: 'Total',
          revenueStat: _projectionService.totalRevenue,
          ebitdaStat: _projectionService.totalEbtda,
          netIncomeStat: _projectionService.totalNetIncome),
      _buildStat(
          name: 'Average',
          revenueStat: _projectionService.totalRevenue / count,
          ebitdaStat: _projectionService.totalEbtda / count,
          netIncomeStat: _projectionService.totalNetIncome / count),
      _buildStat(
          name: 'Total (Projected)',
          revenueStat: _projectionService.totalProjectedRevenue,
          ebitdaStat: _projectionService.totalProjectedEbtda,
          netIncomeStat: _projectionService.totalProjectedNetIncome),
      _buildStat(
          name: 'Average (Projected)',
          revenueStat: _projectionService.revenueProjectedAverage,
          ebitdaStat: _projectionService.ebitdaProjectedAverage,
          netIncomeStat: _projectionService.netIncomeProjectedAverage),
    ]);

    _rows.add(_buildEmptyRow());

    _rows.addAll([
      _buildStat(
        name: 'Multiplier',
        revenueStat: _projectionService.revenueMultiplier,
        ebitdaStat: _projectionService.ebitdaMultiplier,
        netIncomeStat: _projectionService.netIncomeMultiplier,
      ),
      _buildStat(
        name: 'Estimated Value',
        revenueStat: _projectionService.revenueEstimatedValue,
        ebitdaStat: _projectionService.ebitdaEstimatedValue,
        netIncomeStat: _projectionService.netIncomeEstimatedValue,
      )
    ]);

    return _rows;
  }

  _buildRow({required RowData data}) {
    List<DataCell> cells = [
      DataCell(Text(data.year.toString())),
      DataCell(Text(data.revenueValue == 0
          ? '-'
          : Formatters.toPrice(data.revenueValue.toStringAsFixed(2)))),
      DataCell(Text(Formatters.toPrice(
          data.ebitdaValue == 0 ? '-' : data.ebitdaValue.toStringAsFixed(2)))),
      DataCell(Text(Formatters.toPrice(data.netIncomeValue == 0
          ? '-'
          : data.netIncomeValue.toStringAsFixed(2)))),
    ];
    return AppTableRow(cells: cells);
  }

  _buildEmptyRow() {
    List<DataCell> cells = const [
      DataCell(Text('')),
      DataCell(Text('')),
      DataCell(Text('')),
      DataCell(Text('')),
    ];
    return AppTableRow(cells: cells);
  }

  _buildStat({
    required String name,
    required double revenueStat,
    required double ebitdaStat,
    required double netIncomeStat,
  }) {
    List<DataCell> cells = [
      DataCell(Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.w500),
      )),
      DataCell(Text(
        revenueStat == 0
            ? '-'
            : Formatters.toPrice(revenueStat.toStringAsFixed(2)),
        style: const TextStyle(fontWeight: FontWeight.w500),
      )),
      DataCell(Text(
        ebitdaStat == 0
            ? '-'
            : Formatters.toPrice(ebitdaStat.toStringAsFixed(2)),
        style: const TextStyle(fontWeight: FontWeight.w500),
      )),
      DataCell(Text(
        netIncomeStat == 0
            ? '-'
            : Formatters.toPrice(netIncomeStat.toStringAsFixed(2)),
        style: const TextStyle(fontWeight: FontWeight.w500),
      )),
    ];
    return AppTableRow(cells: cells, isHighlighted: false);
  }

  setYearsToProject(int? value) {
    _projectionService.setYearsToProject(years: value!);
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_projectionService];
}
