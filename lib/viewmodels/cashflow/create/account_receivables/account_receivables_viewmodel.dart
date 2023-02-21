import 'package:mpg_mobile/ui/views/cashflow/create/account_receivables/create_account_receivable_view.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:mpg_mobile/constants/utils.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/services/dialog_service.dart';
import 'package:mpg_mobile/services/ui/cashflow/cashflow_create_service.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';

class AccountReceivablesViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _cashFlowCreateService = locator<CashFlowCreateService>();

  final List<DataColumn> _columns = const [
    DataColumn(label: Text('Description')),
    DataColumn(label: Text('Due Date')),
    DataColumn(label: Text('Amount')),
  ];

  List<AppTableRow> get rows {
    double total = 0;
    List<AppTableRow> result =
        _cashFlowCreateService.accountReceivables.map((e) {
      total += e.amount;
      return AppTableRow(cells: [
        DataCell(Text(e.description)),
        DataCell(Text(dateFormat.format(e.date))),
        DataCell(Text('\$ ${e.amount.toStringAsFixed(2)}'))
      ]);
    }).toList();
    result.add(AppTableRow(cells: [
      const DataCell(Text(
        'Total',
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      const DataCell(Text('')),
      DataCell(Text('\$ ${total.toStringAsFixed(2)}'))
    ]));
    return result;
  }

  List<DataColumn> get columns => _columns;

  onAdd() async {
    await _dialogService.showDialog(
        title: 'Add Account Receivable',
        content: const CreateAccountReceivableView(),
        showConfirmButton: false);
    notifyListeners();
  }
}
