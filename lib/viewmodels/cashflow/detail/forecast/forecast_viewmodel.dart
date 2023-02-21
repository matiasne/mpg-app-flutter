import 'package:flutter/material.dart';
import 'package:mpg_mobile/constants/utils.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/services/ui/cashflow/cashflow_forecast_service.dart';
import 'package:mpg_mobile/ui/widgets/form_select_field.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:mpg_mobile/util/formatters.dart';
import 'package:stacked/stacked.dart';

class ForecastViewModel extends BaseViewModel {
  final _cashflowForecastService = locator<CashflowForecastService>();

  int _weeksToProject = 5;
  int get weeksToProject => _weeksToProject;

  int _tableType = 1;
  int get tableType => _tableType;

  List<int> typesWithFrequence = [TableType.debt, TableType.clientRev];

  List<ForecastRowContent> rowsContent = [];

  List<AppSelectOption> weeks = [
    AppSelectOption(label: '4 Weeks', value: 4),
    AppSelectOption(label: '5 Weeks', value: 5),
    AppSelectOption(label: '6 Weeks', value: 6),
    AppSelectOption(label: '7 Weeks', value: 7),
    AppSelectOption(label: '8 Weeks', value: 8),
    AppSelectOption(label: '9 Weeks', value: 9),
    AppSelectOption(label: '10 Weeks', value: 10),
    AppSelectOption(label: '11 Weeks', value: 11),
    AppSelectOption(label: '12 Weeks', value: 12),
    AppSelectOption(label: '13 Weeks', value: 13),
  ];

  List<AppSelectOption> tableTypes = [
    AppSelectOption(label: 'Cashflow', value: 1),
    AppSelectOption(label: 'A/R', value: 2),
    AppSelectOption(label: 'A/P', value: 3),
    AppSelectOption(label: 'Change Impact', value: 4),
    AppSelectOption(label: 'Debt', value: 5),
    AppSelectOption(label: 'Client Rev', value: 6),
  ];

  List<DataColumn> _columns = [
    const DataColumn(label: Text('Cashflow')),
    const DataColumn(label: Text('Amount')),
    const DataColumn(label: Text('Due Date')),
  ];
  List<DataColumn> get columns {
    String tableLabel =
        tableTypes.firstWhere((t) => t.value == tableType).label;
    _columns = [
      DataColumn(label: Text(tableLabel)),
      if (typesWithFrequence.contains(tableType))
        const DataColumn(label: Text('Freq')),
      const DataColumn(label: Text('Amount')),
      const DataColumn(label: Text('Due Date')),
    ];
    DateTime date = _cashflowForecastService.startDate!;
    for (var i = 0; i < (_weeksToProject); i++) {
      date = date.add(const Duration(days: 7));
      _columns.add(DataColumn(
          label: Text(dateFormat.format(date) + '\n (Week ${i + 1})',
              textAlign: TextAlign.center)));
    }
    return _columns;
  }

  List<AppTableRow> _rows = [];
  List<AppTableRow> get rows => _rows;

  setWeeksToProject(int? value) {
    _weeksToProject = value!;
    _buildTable();
    notifyListeners();
  }

  setTableType(int? value) {
    _tableType = value!;
    _buildTable();
    notifyListeners();
  }

  onModelReady() {
    _buildTable();
  }

  _buildTable() {
    _rows = [];
    _buildRows();
  }

  _buildRows() {
    rowsContent = [];

    rowsContent = _cashflowForecastService.getRowData(
        weeksToProject: weeksToProject, type: tableType);

    for (var k = 0; k < rowsContent.length; k++) {
      _rows.add(_getSingleRow(content: rowsContent[k]));
    }
  }

  _getSingleRow({required ForecastRowContent content}) {
    List<DataCell> cells = [
      DataCell(Text(
        content.description,
        style: const TextStyle(fontWeight: FontWeight.w500),
      )),
      if (typesWithFrequence.contains(tableType))
        DataCell(Text(
          content.freq!,
          style: const TextStyle(fontWeight: FontWeight.w500),
        )),
      DataCell(Text(
        Formatters.toPrice(content.due?.toStringAsFixed(2) ?? ''),
      )),
      content.payDate == null && content.periodNumber == null
          ? const DataCell(Text(''))
          : DataCell(Text(
              content.periodNumber == null
                  ? dateFormat.format(content.payDate!)
                  : 'Day ${content.periodNumber.toString()} of a ${content.freq} period',
            )),
    ];

    for (var i = 0; i < content.weeklyValues.length; i++) {
      double? val = content.weeklyValues[i];
      cells.add(
        DataCell(Text(
          val == null ? '' : Formatters.toPrice(val.toStringAsFixed(2)),
        )),
      );
    }
    return AppTableRow(cells: cells);
  }
}
