import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/material_cost.dart';
import 'package:mpg_mobile/services/ui/cost_estimator/cost_estinator_input_form.service.dart';

class MaterialCostsTable extends StatefulWidget {
  const MaterialCostsTable({Key? key}) : super(key: key);

  @override
  _MaterialCostsTableState createState() => _MaterialCostsTableState();
}

class _MaterialCostsTableState extends State<MaterialCostsTable> {
  final _costsEstimatorService = locator<CostEstimatorFormService>();

  final String _header = "Time & Material Costs";
  List<bool> selected = [];

  TextEditingController descriptionController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  bool _isFormValid = false;

  final _doubleRegex = RegExp(r'^[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)$');

  _getColorByIndex(int index) {
    return MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return Theme.of(context).colorScheme.primary.withOpacity(0.08);
      }
      if (index.isEven) {
        return Colors.grey.withOpacity(0.2);
      }
      return null;
    });
  }

  _validateMaterialCostsForm(StateSetter setState) {
    setState(() {
      _isFormValid = descriptionController.text != '' &&
          quantityController.text != '' &&
          priceController.text != '';
    });
  }

  Future<bool> _showCreateFormDialog() async {
    return await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Material Cost'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                    minLines: 2,
                    maxLines: 2,
                    keyboardType: TextInputType.text,
                    onChanged: (val) => _validateMaterialCostsForm(setState),
                  ),
                  TextFormField(
                    controller: quantityController,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(_doubleRegex),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (val) => _validateMaterialCostsForm(setState),
                  ),
                  TextFormField(
                    controller: priceController,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(_doubleRegex),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    onChanged: (val) => _validateMaterialCostsForm(setState),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed:
                  _isFormValid ? () => Navigator.pop(context, true) : null,
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _generateDataRow(MaterialCost materialCost) {
    return DataRow(
      cells: <DataCell>[
        DataCell(
          Text(
            materialCost.description,
            style: const TextStyle(fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Text(
            materialCost.quantity.toStringAsFixed(2),
            style: const TextStyle(fontSize: 12),
          ),
        ),
        DataCell(
          Text(
            '\$ ' + materialCost.price.toStringAsFixed(2),
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  _clearControllers() {
    descriptionController.clear();
    quantityController.clear();
    priceController.clear();
  }

  _addCostToTable() {
    MaterialCost _newMaterialCost = MaterialCost(
      description: descriptionController.text,
      quantity: double.parse(quantityController.text),
      price: double.parse(priceController.text),
    );

    selected.add(false);
    _costsEstimatorService.addMaterialCost(_newMaterialCost);
    _clearControllers();
    setState(() {});
  }

  _addCost(BuildContext context) async {
    bool dialogResult = await _showCreateFormDialog();
    if (dialogResult) _addCostToTable();
  }

  _deleteSelected() {
    List<int> indexToDelete =
        selected.map((e) => e ? selected.indexOf(e) : -1).toList();

    for (var i in indexToDelete) {
      if (i != -1) {
        _costsEstimatorService.removeMaterialCost(i);
        selected.removeAt(i);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    selected = List.generate(
        _costsEstimatorService.materialCosts.length, (index) => false);
  }

  @override
  void dispose() {
    super.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    priceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<DataColumn> _materialCostsColumns = const <DataColumn>[
      DataColumn(
        label: Text(
          'Description',
          style: TextStyle(fontSize: 12),
        ),
      ),
      DataColumn(
        label: Text(
          'Quantity',
          style: TextStyle(fontSize: 12),
        ),
        numeric: true,
      ),
      DataColumn(
        label: Text(
          'Price',
          style: TextStyle(fontSize: 12),
        ),
        numeric: true,
      ),
    ];

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            _header,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataTable(
          columnSpacing: 20.0,
          columns: _materialCostsColumns,
          rows: List<DataRow>.generate(
            _costsEstimatorService.materialCosts.length,
            (int index) => DataRow(
              color: _getColorByIndex(index),
              cells:
                  _generateDataRow(_costsEstimatorService.materialCosts[index])
                      .cells,
              selected: selected[index],
              onSelectChanged: (bool? value) {
                setState(() {
                  selected[index] = value!;
                });
              },
            ),
          ),
        ),
        ButtonBar(
          children: [
            Visibility(
              child: TextButton.icon(
                onPressed: _deleteSelected,
                icon: const Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
                label: const Text(
                  'DELETE',
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
              ),
              visible: selected.any((el) => el),
            ),
            ElevatedButton.icon(
                onPressed: () => _addCost(context),
                icon: const Icon(Icons.add),
                label: const Text('NEW ENTRY'))
          ],
        )
      ],
    );
  }
}
