import 'package:flutter/material.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/labor_cost.dart';
import 'package:mpg_mobile/services/ui/cost_estimator/project_detail_service.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:stacked/stacked.dart';

class LaborTrackerViewModel extends BaseViewModel {
  final _projectDetailService = locator<ProjectDetailService>();

  final List<DataColumn> _columns = const [
    DataColumn(label: Text('Name')),
    DataColumn(label: Text('Hours')),
    DataColumn(label: Text('Rate')),
    DataColumn(label: Text('Amount')),
  ];

  final List<DataColumn> _laborBurdenColumns = const [
    DataColumn(label: Text('Labor')),
    DataColumn(label: Text('Labor Burden Rate')),
    DataColumn(label: Text('Amount')),
  ];

  final List<DataColumn> _fringeRateColumns = const [
    DataColumn(label: Text('Fringe Rate')),
    DataColumn(label: Text('Amount')),
  ];

  final List<AppTableRow> _rows = [];
  final List<AppTableRow> _laborBurdenRows = [];
  final List<AppTableRow> _fringeRateRows = [];

  double _fringeRate = 0.0;
  double _totalCost = 0.0;
  double _totalHours = 0.0;
  double _taxRatio = 0.0;
  double _percentOfSales = 0.0;

  double _fringeRatePercentOfSales = 0.0;
  double _laborBurdenPercentOfSales = 0.0;

  List<DataColumn> get columns => _columns;
  List<AppTableRow> get rows => _rows;

  List<DataColumn> get laborBurdenColumns => _laborBurdenColumns;
  List<AppTableRow> get laborBurdenRows => _laborBurdenRows;

  List<DataColumn> get fringeRateColumns => _fringeRateColumns;
  List<AppTableRow> get fringeRateRows => _fringeRateRows;

  onModelReady() {
    _initializeVariables();
    _buildTable();
    _buildLaborBurdenTable();
    _buildFringeRateTable();
  }

  _initializeVariables() {
    _percentOfSales = _projectDetailService.laborPercentOfSales;
    _fringeRate = _projectDetailService.fringeRate;
    _totalCost = _projectDetailService.totalLaborCost;
    _taxRatio = _projectDetailService.taxRatio;
    _totalHours = _projectDetailService.totalLaborHours;
    _laborBurdenPercentOfSales =
        _projectDetailService.totalLaborBurdenPercentOfSales;
    _fringeRatePercentOfSales = _projectDetailService.fringeRatePercentOfSales;
  }

  _buildTable() {
    for (var lc in _projectDetailService.laborCosts) {
      _buildRow(laborCost: lc);
    }

    _buildNonBillableHoursRow();
    _buildTotalRow();
    _buildPercentOfSalesRow();
  }

  _buildRow({required LaborCost laborCost}) {
    List<DataCell> cells = [
      DataCell(Text(laborCost.name)),
      DataCell(Text(laborCost.hours.toString())),
      DataCell(Text('\$' + laborCost.rate.toString())),
      DataCell(Text('\$' + (laborCost.hours * laborCost.rate).toString())),
    ];
    AppTableRow row = AppTableRow(cells: cells);
    _rows.add(row);
  }

  _buildNonBillableHoursRow() {
    double nonBillableHours = _projectDetailService.nonBillableLaborHours;
    double nonBillableRate = _projectDetailService.nonBillableLaborRate;

    _rows.add(AppTableRow(cells: [
      const DataCell(
        Text('Non Billable Hours',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      DataCell(
        Text(nonBillableHours.toStringAsFixed(2)),
      ),
      DataCell(
        Text('\$' + nonBillableRate.toStringAsFixed(2)),
      ),
      DataCell(
        Text('\$' + (nonBillableHours * nonBillableRate).toStringAsFixed(2)),
      ),
    ]));
  }

  _buildTotalRow() {
    _rows.add(AppTableRow(cells: [
      const DataCell(
        Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      DataCell(
        Text(_totalHours.toStringAsFixed(2)),
      ),
      const DataCell(
        Text(''),
      ),
      DataCell(
        Text('\$' + _totalCost.toString()),
      ),
    ]));
  }

  _buildPercentOfSalesRow() {
    _rows.add(AppTableRow(cells: [
      const DataCell(
        Text('Percent of Sales', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      const DataCell(
        Text(''),
      ),
      const DataCell(
        Text(''),
      ),
      DataCell(
        Text(_percentOfSales.toStringAsFixed(2) + ' %'),
      ),
    ]));
  }

  _buildLaborBurdenTable() {
    _laborBurdenRows.add(AppTableRow(cells: [
      DataCell(
        Text(_totalCost.toStringAsFixed(2)),
      ),
      DataCell(
        Text(
          _taxRatio.toStringAsFixed(2) + '%',
          textAlign: TextAlign.center,
        ),
      ),
      DataCell(
        Text('\$' + (_totalCost * _taxRatio / 100).toStringAsFixed(2)),
      ),
    ]));

    _laborBurdenRows.add(AppTableRow(cells: [
      const DataCell(
        Text(
          'Percent of sales',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      const DataCell(
        Text(''),
      ),
      DataCell(
        Text((_laborBurdenPercentOfSales).toStringAsFixed(2) + ' %'),
      ),
    ]));
  }

  _buildFringeRateTable() {
    _fringeRateRows.add(AppTableRow(cells: [
      DataCell(
        Text(_fringeRate.toStringAsFixed(2) + ' %'),
      ),
      DataCell(
        Text('\$' + (_totalCost * _fringeRate / 100).toStringAsFixed(2)),
      ),
    ]));

    _fringeRateRows.add(AppTableRow(cells: [
      const DataCell(
        Text(
          'Percent of sales',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      DataCell(
        Text((_fringeRatePercentOfSales).toStringAsFixed(2) + ' %'),
      ),
    ]));
  }
}
