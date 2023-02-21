import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mpg_mobile/constants/utils.dart';
import 'package:mpg_mobile/models/weekly_hour.dart';
import 'package:mpg_mobile/services/api/project_service.dart';
import 'package:mpg_mobile/services/ui/cost_estimator/project_detail_service.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:stacked/stacked.dart';

import '../../../locator.dart';

class LaborTrackerDetailViewModel extends BaseViewModel {
  final _projectDetailService = locator<ProjectDetailService>();
  final _projectService = locator<ProjectService>();

  final List<DataColumn> _columns = const [
    DataColumn(label: Text('Week Ending')),
    DataColumn(label: Text('Billable Hours')),
    DataColumn(label: Text('Labor Expense')),
    DataColumn(label: Text('Tax Burden')),
    DataColumn(label: Text('Total')),
  ];

  List<AppTableRow> _rows = [];

  final List<DataColumn> _balanceColumns = const [
    DataColumn(label: Text('')),
    DataColumn(label: Text('Hours')),
    DataColumn(label: Text('Amount')),
  ];

  DateTime? _startDate;
  DateTime? _endDate;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  List<AppTableRow> _balanceRows = [];

  List<DataColumn> get columns => _columns;
  List<AppTableRow> get rows => _rows;

  List<DataColumn> get balanceColumns => _balanceColumns;
  List<AppTableRow> get balanceRows => _balanceRows;

  List<WeeklyHour> _weeklyHours = [];
  final List<WeeklyHour> _updatedWeeklyHours = [];
  double _nonBillableHoursRate = 0.0;
  double _taxRatio = 0.0;

  double _totalHours = 0.0;
  double _totalLaborExpense = 0.0;
  double _totalTaxBurden = 0.0;
  double _totalLabor = 0.0;

  double _initialTotalHours = 0.0;
  double _initialTotalLaborCost = 0.0;
  double _totalLaborBurdenCost = 0.0;

  bool get isUpdated => _updatedWeeklyHours.isNotEmpty;

  onModelReady() {
    if (_projectDetailService.weeklyHours == null) return;
    _initializeVariables();
    _buildTable();
    _buildBalanceTable();
  }

  _initializeVariables() {
    _startDate = _projectDetailService.startDate;
    _endDate = _projectDetailService.endDate;

    _weeklyHours = _projectDetailService.weeklyHours!;
    _nonBillableHoursRate = _projectDetailService.nonBillableLaborRate;
    _taxRatio = _projectDetailService.taxRatio;
    _initialTotalHours = _projectDetailService.totalLaborHours;
    _initialTotalLaborCost = _projectDetailService.totalLaborCost;
    _totalLaborBurdenCost = _projectDetailService.totalLaborBurden;
  }

  _buildTable() {
    _totalHours = 0;
    _totalLaborExpense = 0;
    _totalTaxBurden = 0;
    _totalLabor = 0;
    for (var w in _weeklyHours) {
      double laborExpense = _nonBillableHoursRate * w.hours;
      double taxBurden = laborExpense * _taxRatio / 100;
      double total = laborExpense + taxBurden;

      _totalHours += w.hours;
      _totalLaborExpense += laborExpense;
      _totalTaxBurden += taxBurden;
      _totalLabor += total;

      _buildRow(
          weeklyHour: w,
          laborExpense: laborExpense,
          taxBurden: taxBurden,
          total: total);
    }
    _buildTotalsRow();
  }

  _resetTables() {
    _rows = [];
    _balanceRows = [];
    _buildTable();
    _buildBalanceTable();
  }

  _buildBalanceTable() {
    double totalInitialCost = _initialTotalLaborCost + _totalLaborBurdenCost;
    double totalDifference = totalInitialCost - _totalLabor;

    List<DataCell> cellsFirstRow = [
      const DataCell(Text(
        'Labor budget',
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      DataCell(Text(_initialTotalHours.toStringAsFixed(2))),
      DataCell(Text('\$' + totalInitialCost.toStringAsFixed(2))),
    ];
    List<DataCell> cellsSecondRow = [
      const DataCell(Text(
        'Labor balance',
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      DataCell(Text((_totalHours - _initialTotalHours).toStringAsFixed(2))),
      DataCell(Text(
        '\$' + totalDifference.toStringAsFixed(2),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: totalDifference < 0.0 ? Colors.redAccent : Colors.greenAccent,
        ),
      )),
    ];

    AppTableRow firstRow = AppTableRow(cells: cellsFirstRow);
    AppTableRow secondRow = AppTableRow(cells: cellsSecondRow);
    _balanceRows.add(firstRow);
    _balanceRows.add(secondRow);
  }

  _buildRow({
    required WeeklyHour weeklyHour,
    required double laborExpense,
    required double taxBurden,
    required double total,
  }) {
    List<DataCell> cells = [
      DataCell(Text(dateFormat.format(weeklyHour.day))),

      // Creates an input field and updates the value
      DataCell(TextFormField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(doubleRegex),
        ],
        initialValue: weeklyHour.hours.toString(),
        onChanged: (val) => onInputChanged(weeklyHour: weeklyHour, newVal: val),
      )),

      DataCell(Text('\$' + laborExpense.toStringAsFixed(2))),
      DataCell(Text('\$' + taxBurden.toStringAsFixed(2))),
      DataCell(Text('\$' + total.toStringAsFixed(2))),
    ];
    AppTableRow row = AppTableRow(cells: cells);
    _rows.add(row);
  }

  onInputChanged({required WeeklyHour weeklyHour, required String newVal}) {
    if (newVal == '' || weeklyHour.hours == double.parse(newVal)) return;

    weeklyHour.hours = double.parse(newVal);
    _updatedWeeklyHours.add(weeklyHour);
    notifyListeners();
  }

  Future onSaveWeeklyHours() async {
    int projectId = _projectDetailService.projectId!;

    setBusy(true);
    await _projectService.projectPatchById(
      id: projectId,
      weeklyHours: _weeklyHours,
    );
    _resetTables();
    setBusy(false);
  }

  _buildTotalsRow() {
    List<DataCell> cells = [
      const DataCell(Text(
        'Total',
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      DataCell(Text(
        _totalHours.toStringAsFixed(2),
        style: const TextStyle(fontWeight: FontWeight.bold),
      )),
      DataCell(Text(
        '\$' + _totalLaborExpense.toStringAsFixed(2),
        style: const TextStyle(fontWeight: FontWeight.bold),
      )),
      DataCell(Text(
        '\$' + _totalTaxBurden.toStringAsFixed(2),
        style: const TextStyle(fontWeight: FontWeight.bold),
      )),
      DataCell(Text(
        '\$' + _totalLabor.toStringAsFixed(2),
        style: const TextStyle(fontWeight: FontWeight.bold),
      )),
    ];
    AppTableRow row = AppTableRow(cells: cells);
    _rows.add(row);
  }
}
