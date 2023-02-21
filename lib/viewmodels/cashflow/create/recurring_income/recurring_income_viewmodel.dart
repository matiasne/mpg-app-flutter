import 'package:flutter/material.dart';
import 'package:mpg_mobile/constants/utils.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/services/dialog_service.dart';
import 'package:mpg_mobile/services/ui/cashflow/cashflow_create_service.dart';
import 'package:mpg_mobile/ui/views/cashflow/create/recurring_income/create_recurring_income_view.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:stacked/stacked.dart';

class RecurringIncomeViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _cashFlowCreateService = locator<CashFlowCreateService>();

  final List<DataColumn> _columns = const [
    DataColumn(label: Text('Description')),
    DataColumn(label: Text('Freq.')),
    DataColumn(label: Text('Due Date')),
    DataColumn(label: Text('Amount')),
  ];

  List<AppTableRow> get rows {
    return _cashFlowCreateService.recurringIncomes
        .map((e) => AppTableRow(cells: [
              DataCell(Text(e.description)),
              DataCell(Text(e.freq)),
              DataCell(Text(dateFormat.format(e.date))),
              DataCell(Text('\$ ${e.amount.toStringAsFixed(2)}'))
            ]))
        .toList();
  }

  List<DataColumn> get columns => _columns;

  onAdd() async {
    await _dialogService.showDialog(
        title: 'Add Recurring Income',
        content: const CreateRecurringIncomeView(),
        showConfirmButton: false);
    notifyListeners();
  }
}
