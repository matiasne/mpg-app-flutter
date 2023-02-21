import 'package:flutter/material.dart';
import 'package:mpg_mobile/models/material_cost.dart';
import 'package:mpg_mobile/services/ui/cost_estimator/project_detail_service.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:stacked/stacked.dart';

import '../../../../locator.dart';

class MaterialCostViewModel extends BaseViewModel {
  final _projectDetailService = locator<ProjectDetailService>();

  final List<DataColumn> _columns = const [
    DataColumn(label: Text('Description')),
    DataColumn(label: Text('Quantity')),
    DataColumn(label: Text('Price')),
    DataColumn(label: Text('Amount')),
  ];

  final List<AppTableRow> _rows = [];

  double _totalMaterialCost = 0.0;
  double _percentOfSales = 0.0;

  List<DataColumn> get columns => _columns;
  List<AppTableRow> get rows => _rows;

  onModelReady() {
    _initializeVariables();
    _buildTable();
  }

  _initializeVariables() {
    _totalMaterialCost = _projectDetailService.totalMaterialCost;
    _percentOfSales = _projectDetailService.materialPercentOfSales;
  }

  _buildTable() {
    for (var mc in _projectDetailService.materialCosts) {
      _buildRow(materialCost: mc);
    }
    _buildTotalRow();
    _buildPercentOfSalesRow();
  }

  _buildRow({required MaterialCost materialCost}) {
    List<DataCell> cells = [
      DataCell(Text(materialCost.description)),
      DataCell(Text(materialCost.quantity.toString())),
      DataCell(Text('\$' + materialCost.price.toString())),
      DataCell(
          Text('\$' + (materialCost.quantity * materialCost.price).toString())),
    ];
    AppTableRow row = AppTableRow(cells: cells);
    _rows.add(row);
  }

  _buildTotalRow() {
    _rows.add(AppTableRow(cells: [
      const DataCell(
        Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      const DataCell(
        Text(''),
      ),
      const DataCell(
        Text(''),
      ),
      DataCell(
        Text('\$' + _totalMaterialCost.toString()),
      ),
    ]));
  }

  _buildPercentOfSalesRow() {
    _rows.add(AppTableRow(cells: [
      const DataCell(
        Text('Percent of Sales', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      const DataCell(
        Text(''),
      ),
      const DataCell(
        Text(''),
      ),
      DataCell(
        Text(_percentOfSales.toStringAsFixed(2) + ' %'),
      ),
    ]));
  }
}
