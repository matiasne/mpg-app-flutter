import 'package:flutter/material.dart';
import 'package:mpg_mobile/constants/utils.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/services/ui/cashflow/cashflow_annualized_service.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:mpg_mobile/util/formatters.dart';
import 'package:stacked/stacked.dart';

class AnnualizedViewModel extends BaseViewModel {
  final _annualizedService = locator<CashflowAnnualizedService>();

  final List<DataColumn> _recurringColumns = const [
    DataColumn(label: Text('Description')),
    DataColumn(label: Text('Freq')),
    DataColumn(label: Text('Due Date')),
    DataColumn(label: Text('Amount')),
    DataColumn(label: Text('Annualized Impact')),
    DataColumn(label: Text('%')),
  ];
  List<DataColumn> get recurringColumns => _recurringColumns;
  List<AppTableRow> _recurringRows = [];
  List<AppTableRow> get recurringRows => _recurringRows;

  final List<DataColumn> _oneTimeColumns = const [
    DataColumn(label: Text('Description')),
    DataColumn(label: Text('Due Date')),
    DataColumn(label: Text('Amount')),
    DataColumn(label: Text('%')),
  ];
  List<DataColumn> get oneTimeColumns => _oneTimeColumns;
  List<AppTableRow> _oneTimeRows = [];
  List<AppTableRow> get oneTimeRows => _oneTimeRows;

  double totalCurrent = 0;

  onModelReady() {
    _buildRecurringTable();
    _buildOneTimeTable();
    _computeAnnualized();
    notifyListeners();
  }

  _buildRecurringTable() {
    _recurringRows = [];
    _buildRecurringRows();
  }

  _buildOneTimeTable() {
    _oneTimeRows = [];
    _buildOneTimeRows();
  }

  _computeAnnualized() {
    totalCurrent = _annualizedService.total;
  }

  _buildRecurringRows() {
    List<RecurringIncomeRowData> rowsData =
        _annualizedService.computeRecurringRowsData();

    for (var r in rowsData) {
      List<DataCell> cells = [
        DataCell(Text(
          r.description,
          style: const TextStyle(fontWeight: FontWeight.w500),
        )),
        DataCell(Text(
          r.isTotal ? '' : r.freq,
          style: const TextStyle(fontWeight: FontWeight.w500),
        )),
        DataCell(Text(
          r.isTotal ? '' : dateFormat.format(r.dueDate),
        )),
        DataCell(Text(
          r.isTotal
              ? ''
              : '\$${Formatters.toPrice(r.amount.toStringAsFixed(2))}',
        )),
        DataCell(Text(
          '\$${Formatters.toPrice(r.annualizedImpact.toStringAsFixed(2))}',
        )),
        DataCell(Text(
          '${r.percent.toStringAsFixed(2)}%',
        )),
      ];

      _recurringRows.add(AppTableRow(cells: cells));
    }
  }

  _buildOneTimeRows() {
    List<OneTimeEffectRowData> rowsData =
        _annualizedService.computeOneTimeRowsData();

    for (var r in rowsData) {
      List<DataCell> cells = [
        DataCell(Text(
          r.description,
          style: const TextStyle(fontWeight: FontWeight.w500),
        )),
        DataCell(Text(
          r.isTotal ? '' : dateFormat.format(r.dueDate),
        )),
        DataCell(Text(
          '\$${Formatters.toPrice(r.amount.toStringAsFixed(2))}',
        )),
        DataCell(Text(
          '${r.percent.toStringAsFixed(2)}%',
        )),
      ];

      _oneTimeRows.add(AppTableRow(cells: cells));
    }
  }
}
