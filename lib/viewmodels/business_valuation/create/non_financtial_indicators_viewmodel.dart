import 'package:flutter/material.dart';
import 'package:mpg_mobile/extensions/input_formatter_extensions.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/services/ui/business_valuation/business_valuation_create_service.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:stacked/stacked.dart';

class NonFinanctialIndicatorsViewModel extends BaseViewModel {
  final _businessValuationService = locator<BusinessValuationCreateService>();

  final List<DataColumn> _columns = [
    const DataColumn(label: Text('Business core values')),
    DataColumn(
      label: Row(
        children: const [
          Text('Weight (1 to 7)'),
          SizedBox(
            width: 5,
          ),
          Tooltip(
            triggerMode: TooltipTriggerMode.tap,
            padding: EdgeInsets.all(5),
            child: Icon(
              Icons.help_outline,
              size: 14,
            ),
            textStyle: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
            message: 'Rank your business Core Values from 7 '
                '(most important)\nto 1 (least important) '
                'regarding the functionality of your business.',
          ),
        ],
      ),
    ),
    DataColumn(
      label: Row(
        children: const [
          Text('Ranking (1 to 10)'),
          SizedBox(
            width: 5,
          ),
          Tooltip(
            triggerMode: TooltipTriggerMode.tap,
            padding: EdgeInsets.all(5),
            child: Icon(
              Icons.help_outline,
              size: 14,
            ),
            textStyle: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
            message: 'Then give each Core value a ranking '
                'from 10 (exceptional)\nto 1 (poor) based on '
                'its current performance.',
          ),
        ],
      ),
    ),
  ];

  final List<AppTableRow> _rows = [];

  List<AppTableRow> get rows => _rows;
  List<DataColumn> get columns => _columns;

  onModelReady() {
    _buildTable();
  }

  _buildTable() {
    for (var indicator in _businessValuationService.nonFinanctialIndicators) {
      _buildRow(indicator: indicator);
    }
  }

  _buildRow({required NonFinanctialIndicatorInput indicator}) {
    List<DataCell> cells = [
      DataCell(Text(indicator.name)),
      DataCell(TextField(
        controller: indicator.weightController,
        inputFormatters: [NumericalRangeFormatter(max: 7, min: 1)],
      )),
      DataCell(TextField(
        controller: indicator.rankingController,
        inputFormatters: [NumericalRangeFormatter(max: 10, min: 1)],
      )),
    ];
    AppTableRow row = AppTableRow(cells: cells);
    _rows.add(row);
  }
}
