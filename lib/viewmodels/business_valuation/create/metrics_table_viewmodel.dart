import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mpg_mobile/constants/utils.dart';
import 'package:mpg_mobile/extensions/input_formatter_extensions.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/services/ui/business_valuation/business_valuation_create_service.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:stacked/stacked.dart';
import 'package:mpg_mobile/extensions/string_extensions.dart';

class MetricsTableViewModel extends BaseViewModel {
  final _businessValuationCreateService =
      locator<BusinessValuationCreateService>();

  List<FinanctialIndicatorRowData> financtialIndicators = [];

  final List<DataColumn> _columns = const [
    DataColumn(label: Text('Metric')),
    DataColumn(label: Text('Year')),
    DataColumn(label: Text('Amount (\$)')),
    DataColumn(label: Text('Proj. Annual Growth (%)')),
  ];

  List<AppTableRow> _rows = [];

  List<AppTableRow> get rows => _rows;
  List<DataColumn> get columns => _columns;

  onModelReady() {
    _loadData();
    _buildTable();
  }

  _buildTable() {
    for (var fi in financtialIndicators) {
      _buildRow(data: fi);
    }
  }

  _buildRow({required FinanctialIndicatorRowData data}) {
    List<DataCell> cells = [
      DataCell(Text(data.name)),
      DataCell(Text('${DateTime.now().year}')),
      DataCell(
        TextField(
          controller: data.controller,
          onChanged: data.onChanged,
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
          onChanged: data.onGrowthChanged,
          controller: data.growthController,
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

  _loadData() {
    financtialIndicators = [
      FinanctialIndicatorRowData(
        name: 'Revenue',
        controller: _businessValuationCreateService.financtialRevenueController,
        onChanged: onRevenueChanged,
        onGrowthChanged: onRevenueGrowthChanged,
        growthController:
            _businessValuationCreateService.financtialRevenueGrowthController,
      ),
      FinanctialIndicatorRowData(
        name: 'EBITDA',
        controller: _businessValuationCreateService.financtialEBITDAController,
        onChanged: onEBITDAChanged,
        growthController:
            _businessValuationCreateService.financtialEBITDAGrowthController,
      ),
      FinanctialIndicatorRowData(
        name: 'SDI',
        controller: _businessValuationCreateService.financtialSDIController,
        growthController:
            _businessValuationCreateService.financtialSDIGrowthController,
      ),
    ];
  }

  onRevenueChanged(String val) {
    _businessValuationCreateService.setRevenue(val.parseDouble());
  }

  onRevenueGrowthChanged(String val) {
    return _businessValuationCreateService.setRevenueGrowth(val.parseDouble());
  }

  onEBITDAChanged(String val) {
    return _businessValuationCreateService.setEBITDA(val.parseDouble());
  }

  @override
  void dispose() {
    _rows = [];
    super.dispose();
  }
}

class FinanctialIndicatorRowData {
  String name;
  TextEditingController controller;
  void Function(String)? onChanged;
  void Function(String)? onGrowthChanged;
  TextEditingController growthController;

  FinanctialIndicatorRowData({
    required this.name,
    required this.controller,
    this.onChanged,
    required this.growthController,
    this.onGrowthChanged,
  });
}
