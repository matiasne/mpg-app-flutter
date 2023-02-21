import 'package:flutter/material.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/services/ui/business_valuation/profit_loss_service.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:mpg_mobile/util/formatters.dart';
import 'package:stacked/stacked.dart';

class ProjectedProfitLossViewModel extends BaseViewModel {
  final _profitLossService = locator<ProfitLossService>();

  double get initialValuation => _profitLossService.initialValuation;
  double get revisedValuation => _profitLossService.revisedValuation;
  double get difference => _profitLossService.difference;
  int get yearsToProject => _profitLossService.yearsToProject;

  List<DataColumn> _columns = [
    const DataColumn(label: Text('Metric')),
  ];
  List<DataColumn> get columns {
    _columns = [
      const DataColumn(label: Text('Metric')),
    ];
    for (var i = 0; i < yearsToProject + 1; i++) {
      _columns.add(DataColumn(
        label: Text('${DateTime.now().year + i}'),
      ));
    }
    return _columns;
  }

  List<AppTableRow> _rows = [];
  List<AppTableRow> get rows {
    return _rows;
  }

  onModelReady() {
    _buildTable();
  }

  _buildTable() {
    _rows = [];
    _profitLossService.updateTable(type: null, val: null);
    _buildRevenueRow();
    _buildPercentCOGSRow();
    _buildCOGSRow();
    _buildPercentChangeRow();
    _buildGrossProfitRow();
    _buildExpensesRow();
    _buildEBITDARow();
    _buildInitialPaymentRow();
    _buildEquityPaymentRow();
    _buildCumulativePaymentRow();
    _buildNetEarningPaymentRow();
    _buildCumulativeNetRow();
    _buildCumulativeNetRateRow();
  }

  _buildRevenueRow() {
    List<DataCell> cells = [const DataCell(Text('Revenue'))];
    for (var value in _profitLossService.revenueRowData) {
      cells.add(
        DataCell(Text('\$${Formatters.toPrice(value.toStringAsFixed(2))}')),
      );
    }
    _rows.add(AppTableRow(cells: cells));
  }

  _buildPercentCOGSRow() {
    List<DataCell> cells = [const DataCell(Text('COGS (%)'))];
    for (var i = 0; i < _profitLossService.cogsRateRowData.length; i++) {
      double value = _profitLossService.cogsRateRowData[i];
      cells.add(
        DataCell(Text('${value.toStringAsFixed(2)}%')),
      );
    }
    _rows.add(AppTableRow(cells: cells));
  }

  _buildCOGSRow() {
    List<DataCell> cells = [const DataCell(Text('COGS'))];
    for (var value in _profitLossService.cogsRowData) {
      cells.add(
        DataCell(Text('\$${Formatters.toPrice(value.toStringAsFixed(2))}')),
      );
    }
    _rows.add(AppTableRow(cells: cells));
  }

  _buildPercentChangeRow() {
    List<DataCell> cells = [const DataCell(Text('Change (%)'))];
    for (var value in _profitLossService.percentChangeRowData) {
      cells.add(
        DataCell(Text('${value.toStringAsFixed(2)}%')),
      );
    }
    _rows.add(AppTableRow(cells: cells));
  }

  _buildGrossProfitRow() {
    List<DataCell> cells = [const DataCell(Text('Gross Profit'))];
    for (var i = 0; i < _profitLossService.grossProfitRowData.length; i++) {
      var value = _profitLossService.grossProfitRowData[i];
      var rate = _profitLossService.grossProfitRateRowData[i];
      cells.add(
        DataCell(Text(
            '\$${Formatters.toPrice(value.toStringAsFixed(2))} (${rate.toStringAsFixed(2)}%)')),
      );
    }
    _rows.add(AppTableRow(cells: cells));
  }

  _buildExpensesRow() {
    List<DataCell> cells = [const DataCell(Text('Expenses'))];
    for (var i = 0; i < _profitLossService.expensesRowData.length; i++) {
      double value = _profitLossService.expensesRowData[i];
      cells.add(
        DataCell(Text(
          '\$${Formatters.toPrice(value.toStringAsFixed(2))}',
        )),
      );
    }
    _rows.add(AppTableRow(cells: cells));
  }

  _buildEBITDARow() {
    List<DataCell> cells = [const DataCell(Text('EBITDA'))];
    for (var i = 0; i < _profitLossService.ebitdaRow.length; i++) {
      double ebtda = _profitLossService.ebitdaRow[i];
      double ebtdaRate = _profitLossService.ebitdaRateRow[i];
      cells.add(
        DataCell(Text(
            '\$${Formatters.toPrice(ebtda.toStringAsFixed(2))} (${ebtdaRate.toStringAsFixed(2)}%)')),
      );
    }
    _rows.add(AppTableRow(cells: cells));
  }

  _buildInitialPaymentRow() {
    List<DataCell> cells = [const DataCell(Text('Initial Payment'))];
    for (var value in _profitLossService.initialPaymentsRow) {
      cells.add(
        DataCell(Text(
          '\$${Formatters.toPrice(value.toStringAsFixed(2))}',
        )),
      );
    }
    _rows.add(AppTableRow(cells: cells, isHighlighted: true));
  }

  _buildEquityPaymentRow() {
    List<DataCell> cells = [const DataCell(Text('Equity Payments'))];
    for (var value in _profitLossService.equityPaymentsRow) {
      cells.add(
        DataCell(Text(
          '\$${Formatters.toPrice(value.toStringAsFixed(2))}',
        )),
      );
    }
    _rows.add(AppTableRow(cells: cells, isHighlighted: true));
  }

  _buildCumulativePaymentRow() {
    List<DataCell> cells = [const DataCell(Text('Cumulative Payments'))];
    for (var value in _profitLossService.cumulativePaymentsRow) {
      cells.add(
        DataCell(Text(
          '\$${Formatters.toPrice(value.toStringAsFixed(2))}',
        )),
      );
    }
    _rows.add(AppTableRow(cells: cells, isHighlighted: true));
  }

  _buildNetEarningPaymentRow() {
    List<DataCell> cells = [const DataCell(Text('Net Earning'))];
    for (var i = 0; i < _profitLossService.netEarningRow.length; i++) {
      double value = _profitLossService.netEarningRow[i];
      double rate = _profitLossService.netEarningRateRow[i];
      cells.add(
        DataCell(Text(
            '\$${Formatters.toPrice(value.toStringAsFixed(2))} (${rate.toStringAsFixed(2)}%)')),
      );
    }
    _rows.add(AppTableRow(cells: cells));
  }

  _buildCumulativeNetRow() {
    List<DataCell> cells = [const DataCell(Text('Cumulative Net'))];
    for (var i = 0; i < _profitLossService.cumulativeNetRow.length; i++) {
      double value = _profitLossService.cumulativeNetRow[i];
      cells.add(
        DataCell(Text('\$${Formatters.toPrice(value.toStringAsFixed(2))}')),
      );
    }
    _rows.add(AppTableRow(cells: cells));
  }

  _buildCumulativeNetRateRow() {
    List<DataCell> cells = [const DataCell(Text('Cumulative Net'))];
    for (var i = 0; i < _profitLossService.cumulativeNetRateRow.length; i++) {
      double value = _profitLossService.cumulativeNetRateRow[i];
      String valueToShow = value == 0 ? '' : '${value.toStringAsFixed(2)}%';
      cells.add(
        DataCell(Text(
          valueToShow,
          style: const TextStyle(fontWeight: FontWeight.bold),
        )),
      );
    }
    _rows.add(AppTableRow(cells: cells));
  }

  onValueChanged(String val, ValueChangedType type) async {
    double value = double.tryParse(val) ?? 0;
    _profitLossService.updateTable(val: value, type: type);
    _buildTable();
    notifyListeners();
  }
}
