import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mpg_mobile/extensions/input_formatter_extensions.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/non_financtial_indicator.dart';
import 'package:mpg_mobile/services/ui/business_valuation/ranking_service.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:stacked/stacked.dart';

class RankingInputsViewModel extends BaseViewModel {
  final _rankingService = locator<RankingService>();

  final List<DataColumn> _columns = [
    const DataColumn(label: Text('Business Core Values')),
    DataColumn(
      label: Row(
        children: const [
          Text('Weight'),
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
    const DataColumn(label: Text('Ratio')),
    DataColumn(
      label: Row(
        children: const [
          Text('Ranking'),
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
    const DataColumn(label: Text('Score')),
  ];

  List<AppTableRow> _rows = [];

  List<AppTableRow> get rows => _rows;
  List<DataColumn> get columns => _columns;

  int get totalWeight => _rankingService.totalWeight;
  int get totalRanking => _rankingService.totalRanking;
  double get scoreRate => _rankingService.scoreRate;

  onModelReady() {
    _buildTable();
  }

  reload() {
    _buildTable();
    notifyListeners();
  }

  _buildTable() {
    _rows = [];
    for (var fi in _rankingService.nonFinanctialIndicators!) {
      _buildRow(data: fi);
    }
    _buildTotalsRow();
  }

  _buildRow({required NonFinanctialIndicator data}) {
    int totalWeight = _rankingService.totalWeight;
    double weightPercent = (data.weight / totalWeight) * 100;
    List<DataCell> cells = [
      DataCell(Text(data.name)),
      DataCell(
        TextField(
          controller: _getController(
              data.name, data.weight, NonFinanctialIndicatorType.weight),
          onChanged: (val) =>
              _onChanged(data.name, val, NonFinanctialIndicatorType.weight),
          inputFormatters: <TextInputFormatter>[
            NumericalRangeFormatter(min: 1, max: 7),
          ],
        ),
      ),
      DataCell(
        Text('${weightPercent.toStringAsFixed(2)} %'),
      ),
      DataCell(
        TextField(
          controller: _getController(
              data.name, data.ranking, NonFinanctialIndicatorType.ranking),
          onChanged: (val) =>
              _onChanged(data.name, val, NonFinanctialIndicatorType.ranking),
          inputFormatters: <TextInputFormatter>[
            NumericalRangeFormatter(min: 1, max: 10),
          ],
        ),
      ),
      DataCell(
        Text(((weightPercent / 100) * data.ranking).toStringAsFixed(2)),
      ),
    ];
    AppTableRow row = AppTableRow(cells: cells);
    _rows.add(row);
  }

  _buildTotalsRow() {
    int totalWeight = _rankingService.totalWeight;
    int totalRanking = _rankingService.totalRanking;
    double totalScore = _rankingService.totalScore;
    List<DataCell> cells = [
      const DataCell(Text(
        'Total',
        style: TextStyle(fontWeight: FontWeight.w500),
      )),
      DataCell(Text(
        totalWeight.toString(),
        style: const TextStyle(fontWeight: FontWeight.w500),
      )),
      DataCell(Text(
        '${totalWeight / totalWeight * 100} %',
        style: const TextStyle(fontWeight: FontWeight.w500),
      )),
      DataCell(Text(
        totalRanking.toString(),
        style: const TextStyle(fontWeight: FontWeight.w500),
      )),
      DataCell(Text(
        totalScore.toStringAsFixed(2),
        style: const TextStyle(fontWeight: FontWeight.w500),
      )),
    ];
    AppTableRow row = AppTableRow(cells: cells);
    _rows.add(row);
  }

  _getController(String name, int value, NonFinanctialIndicatorType type) {
    return TextEditingController(text: value.toString());
  }

  _onChanged(String name, String value, NonFinanctialIndicatorType type) {
    var nfi = _rankingService.nonFinanctialIndicators!
        .firstWhere((nfi) => nfi.name == name);
    int index = _rankingService.nonFinanctialIndicators!.indexOf(nfi);
    _rankingService.updateNonFinanctialIndicators(value, index, type);

    reload();
  }
}

enum NonFinanctialIndicatorType { weight, ranking }

class IndicatorNames {
  static String financtials = "Good Financials";
  static String team = "Good Team";
  static String processesSystems = "Good processes / systems";
  static String businessModel = "Business Model";
  static String technologyIT = "Technology / IT";
  static String customerBase = "Strong customer base";
  static String brand = "Brand awareness / Competition";
}
