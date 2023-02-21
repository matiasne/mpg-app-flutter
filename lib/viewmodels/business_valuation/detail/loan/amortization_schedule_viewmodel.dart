import 'package:flutter/material.dart';
import 'package:mpg_mobile/constants/utils.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/services/ui/business_valuation/loan.service.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:mpg_mobile/util/formatters.dart';
import 'package:stacked/stacked.dart';

class AmortizationScheduleViewModel extends ReactiveViewModel {
  final _loanService = locator<LoanService>();

  List<AppTableRow> _rows = [];
  final List<DataColumn> _columns = const [
    DataColumn(label: Text('PMT Number')),
    DataColumn(label: Text('Due Date')),
    DataColumn(label: Text('Amount owing')),
  ];

  List<AppTableRow> get rows {
    _rows = [];
    List<ScheduleEntry> entries = _loanService.scheduleEntries;
    for (var entry in entries) {
      _rows.add(_buildRow(entry: entry));
    }
    return _rows;
  }

  List<DataColumn> get columns => _columns;

  _buildRow({required ScheduleEntry entry}) {
    return AppTableRow(cells: [
      DataCell(Text(entry.pmtNumber.toString())),
      DataCell(Text(dateFormat.format(entry.date))),
      DataCell(Text(
          '\$${Formatters.toPrice(entry.amountOwing.toStringAsFixed(2))}')),
    ]);
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_loanService];
}
