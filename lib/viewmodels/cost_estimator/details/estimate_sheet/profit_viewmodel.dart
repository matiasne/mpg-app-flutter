import 'package:flutter/material.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/services/ui/cost_estimator/project_detail_service.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:stacked/stacked.dart';

class _Row {
  double profitRate;
  double profitAmount;
  double pricePerHour;
  double suggestedPrice;

  _Row({
    required this.profitRate,
    required this.profitAmount,
    required this.pricePerHour,
    required this.suggestedPrice,
  });
}

class ProfitViewModel extends BaseViewModel {
  final _projectDetailService = locator<ProjectDetailService>();

  final List<DataColumn> _columns = const [
    DataColumn(label: Text('Profit %')),
    DataColumn(label: Text('Profit revenue')),
    DataColumn(label: Text('Price Per Hour')),
    DataColumn(label: Text('Suggested price')),
  ];

  List<DataColumn> get columns => _columns;

  final List<AppTableRow> _rows = [];

  List<AppTableRow> get rows => _rows;

  double _profitRate = 0.0;
  double get profitRate => _profitRate;

  double _profitRevenue = 0.0;
  double get profitRevenue => _profitRevenue;

  double _totalBreakeven = 0.0;
  double get totalBreakeven => _totalBreakeven;

  double _overhead = 0.0;
  double get overhead => _overhead;

  double _pricePerHour = 0.0;
  double get pricePerHour => _pricePerHour;

  double _suggestedPrice = 0.0;
  double get suggestedPrice => _suggestedPrice;

  onModelReady() {
    _initializeVariables();
    _buildTable();
  }

  _initializeVariables() {
    _profitRate = _projectDetailService.desiredProfitRate;
    _profitRevenue = _projectDetailService.profitAmount;
    _totalBreakeven = _projectDetailService.totalBreakeven;
    _overhead = _projectDetailService.overhead;
    _pricePerHour = _projectDetailService.pricePerHour;
    _suggestedPrice = _projectDetailService.suggestedPrice;
  }

  _buildTable() {
    // builds rows before actual profit rate
    for (var i = _profitRate - 5; i < _profitRate; i++) {
      _Row newRow = _generateEstimation(profitRate: i);
      _buildRow(tableRow: newRow, isPlaydown: true);
    }

    // builds actual profit rate row
    _Row mainRow = _Row(
      pricePerHour: _pricePerHour,
      profitAmount: _profitRevenue,
      profitRate: _profitRate,
      suggestedPrice: _suggestedPrice,
    );
    _buildRow(tableRow: mainRow, isHighlighted: true);

    // builds rows after actual profit rate
    for (var i = _profitRate + 1; i < _profitRate + 6; i++) {
      _Row newRow = _generateEstimation(profitRate: i);
      _buildRow(tableRow: newRow, isPlaydown: true);
    }
  }

  _buildRow({
    required _Row tableRow,
    bool isHighlighted = false,
    bool isPlaydown = false,
  }) {
    List<DataCell> cells = [
      DataCell(Text(
        tableRow.profitRate.toStringAsFixed(2) + ' %',
        style: TextStyle(
          fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
          color: isPlaydown ? Colors.grey[600] : null,
        ),
      )),
      DataCell(Text(
        '\$' + tableRow.profitAmount.toStringAsFixed(2),
        style: TextStyle(
          fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
          color: isPlaydown ? Colors.grey[600] : null,
        ),
      )),
      DataCell(Text(
        '\$' + tableRow.pricePerHour.toStringAsFixed(2),
        style: TextStyle(
          fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
          color: isPlaydown ? Colors.grey[600] : null,
        ),
      )),
      DataCell(Text(
        '\$' + tableRow.suggestedPrice.toStringAsFixed(2),
        style: TextStyle(
          fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
          color: isPlaydown ? Colors.grey[600] : null,
        ),
      )),
    ];
    AppTableRow row = AppTableRow(
      cells: cells,
      isHighlighted: isHighlighted,
      isPlaydown: isPlaydown,
    );
    _rows.add(row);
  }

  _Row _generateEstimation({required double profitRate}) {
    double percentDesiredProfit = profitRate / 100;

    double suggested = 0;
    if (percentDesiredProfit != 1) {
      suggested = _totalBreakeven / (1 - percentDesiredProfit);
    } else {
      suggested = _totalBreakeven;
    }

    double profitAmount = suggested - _totalBreakeven;

    double pricePerHour = 0;
    if (_projectDetailService.totalLaborHours != 0) {
      pricePerHour = suggested / _projectDetailService.totalLaborHours;
    }

    return _Row(
      pricePerHour: pricePerHour,
      profitAmount: profitAmount,
      profitRate: profitRate,
      suggestedPrice: suggested,
    );
  }
}
