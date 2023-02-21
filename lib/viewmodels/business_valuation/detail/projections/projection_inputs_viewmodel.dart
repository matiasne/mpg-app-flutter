import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mpg_mobile/constants/utils.dart';
import 'package:mpg_mobile/extensions/input_formatter_extensions.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/financtial_indicator.dart';
import 'package:mpg_mobile/services/ui/business_valuation/projections.service.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:mpg_mobile/util/formatters.dart';
import 'package:mpg_mobile/viewmodels/business_valuation/create/metrics_table_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ProjectionInputsViewModel extends BaseViewModel {
  final _projectionService = locator<ProjectionsService>();

  List<FinanctialIndicatorRowData> financtialIndicators = [];

  final List<DataColumn> _columns = const [
    DataColumn(label: Text('Metric')),
    DataColumn(label: Text('Year')),
    DataColumn(label: Text('Amount (\$)')),
    DataColumn(label: Text('Proj. Annual Growth (%)')),
  ];

  final List<AppTableRow> _rows = [];

  List<AppTableRow> get rows => _rows;
  List<DataColumn> get columns => _columns;

  var costOfGoodsSoldController = TextEditingController();
  var _financtialRevenueController = TextEditingController();
  var _financtialRevenueGrowthController = TextEditingController();
  var _financtialEBITDAController = TextEditingController();
  var _financtialEBITDAGrowthController = TextEditingController();
  var _financtialNetIncomeController = TextEditingController();
  var _financtialNetIncomeGrowthController = TextEditingController();

  onModelReady() {
    costOfGoodsSoldController =
        TextEditingController(text: _projectionService.cogs.toString());
    _buildTable();
  }

  _buildTable() {
    for (var fi in _projectionService.financtialIndicators!) {
      _buildRow(data: fi);
    }
  }

  _buildRow({required FinanctialIndicator data}) {
    List<DataCell> cells = [
      DataCell(Text(data.name)),
      DataCell(Text('${DateTime.now().year}')),
      DataCell(
        TextField(
          controller: _getController(
              data.name, Formatters.toPrice(data.amount.toStringAsFixed(2))),
          onChanged: (val) => _onAmountChanged(data.name, val),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(priceRegex),
            PriceFormatter(),
          ],
          decoration: const InputDecoration(
            prefix: Text('\$'),
          ),
        ),
      ),
      DataCell(
        TextField(
          onChanged: (val) => _onGrowthChanged(data.name, val),
          controller: _getGrowthController(
              data.name, data.projectedGrowth.toStringAsFixed(2)),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(doubleRegex),
          ],
          decoration: const InputDecoration(
            suffix: Text('%'),
          ),
        ),
      ),
    ];
    AppTableRow row = AppTableRow(cells: cells);
    _rows.add(row);
  }

  TextEditingController _getController(String type, String amount) {
    var newController = TextEditingController(text: amount);
    switch (type) {
      case _FIType.revenue:
        _financtialRevenueController = newController;
        return _financtialRevenueController;
      case _FIType.ebitda:
        _financtialEBITDAController = newController;
        return _financtialEBITDAController;
      case _FIType.netIncome:
        _financtialNetIncomeController = newController;
        return _financtialNetIncomeController;
    }

    return TextEditingController();
  }

  TextEditingController _getGrowthController(String type, String growth) {
    var newController = TextEditingController(text: growth);
    switch (type) {
      case _FIType.revenue:
        _financtialRevenueGrowthController = newController;
        return _financtialRevenueGrowthController;
      case _FIType.ebitda:
        _financtialEBITDAGrowthController = newController;
        return _financtialEBITDAGrowthController;
      case _FIType.netIncome:
        _financtialNetIncomeGrowthController = newController;
        return _financtialNetIncomeGrowthController;
    }

    return TextEditingController();
  }

  _onAmountChanged(String type, String val) {
    String value = Formatters.clearCommas(val);
    switch (type) {
      case _FIType.revenue:
        return onRevenueChanged(value);
      case _FIType.ebitda:
        return onEBITDAChanged(value);
      case _FIType.netIncome:
        return onNetIncomeChanged(value);
    }
  }

  _onGrowthChanged(String type, String val) {
    switch (type) {
      case _FIType.revenue:
        return onRevenueGrowthChanged(val);
      case _FIType.ebitda:
        return onEBITDAGrowthChanged(val);
      case _FIType.netIncome:
        return onNetIncomeGrowthChanged(val);
    }
  }

  onRevenueChanged(String val) {
    _projectionService.setRevenue(val);
  }

  onRevenueGrowthChanged(String val) =>
      _projectionService.setRevenueGrowth(val);

  onEBITDAChanged(String val) {
    _projectionService.setEBITDA(val);
  }

  onEBITDAGrowthChanged(String val) => _projectionService.setEBITDAGrowth(val);

  onNetIncomeChanged(String val) {
    _projectionService.setNetIncome(val);
  }

  onNetIncomeGrowthChanged(String val) =>
      _projectionService.setNetIncomeGrowth(val);

  onCogsChanged(String val) => _projectionService.setCogs(val);
}

class _FIType {
  static const String revenue = 'Revenue';
  static const String ebitda = 'EBITDA';
  static const String netIncome = 'SDI';
}
