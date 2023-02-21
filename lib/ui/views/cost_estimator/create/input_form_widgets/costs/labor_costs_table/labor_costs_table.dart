import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/labor_cost.dart';
import 'package:mpg_mobile/services/ui/cost_estimator/cost_estinator_input_form.service.dart';

class LaborCostsTable extends StatefulWidget {
  const LaborCostsTable({Key? key}) : super(key: key);

  @override
  _LaborCostsTableState createState() => _LaborCostsTableState();
}

class _LaborCostsTableState extends State<LaborCostsTable> {
  final _costsEstimatorService = locator<CostEstimatorFormService>();

  final String _header = "Labor Costs";
  List<bool> selected = [];

  double _nonBillableHours = 0.0;
  double _nonBillableRate = 0.0;

  TextEditingController nameController = TextEditingController();
  TextEditingController hoursController = TextEditingController();
  TextEditingController rateController = TextEditingController();
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
      _isFormValid = nameController.text != '' &&
          hoursController.text != '' &&
          rateController.text != '';
    });
  }

  Future<bool?> _showCreateFormDialog() async {
    return await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Labor Cost'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                    minLines: 2,
                    maxLines: 2,
                    keyboardType: TextInputType.text,
                    onChanged: (val) => _validateMaterialCostsForm(setState),
                  ),
                  TextFormField(
                    controller: hoursController,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(_doubleRegex),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Hours',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: rateController,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(_doubleRegex),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Rate',
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

  DataRow _generateDataRow(LaborCost _newRow) {
    return DataRow(
      cells: <DataCell>[
        DataCell(
          Text(
            _newRow.name,
            style: const TextStyle(fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Text(
            _newRow.hours.toStringAsFixed(2),
            style: const TextStyle(fontSize: 12),
          ),
        ),
        DataCell(
          Text(
            '\$ ' + _newRow.rate.toStringAsFixed(2),
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  _clearControllers() {
    nameController.clear();
    hoursController.clear();
    rateController.clear();
  }

  _addCostToTable() {
    LaborCost _newLaborCost = LaborCost(
      name: nameController.text,
      hours: double.parse(hoursController.text),
      rate: double.parse(rateController.text),
    );

    selected.add(false);
    _costsEstimatorService.addLaborCost(_newLaborCost);
    _updateNonBillableValues();
    _clearControllers();
    setState(() {});
  }

  _addCost(BuildContext context) async {
    bool? dialogResult = await _showCreateFormDialog();
    if (dialogResult != null && dialogResult) _addCostToTable();
  }

  _deleteSelected() {
    List<int> indexToDelete =
        selected.map((e) => e ? selected.indexOf(e) : -1).toList();
    for (var i in indexToDelete) {
      if (i != -1) {
        _costsEstimatorService.removeLaborCost(i);
        selected.removeAt(i);
      }
    }
    _updateNonBillableValues();
  }

  _updateNonBillableValues() {
    var totalHours = 0.0;
    var totalRate = 0.0;
    var totalCosts = _costsEstimatorService.laborCosts.length;
    for (var lc in _costsEstimatorService.laborCosts) {
      totalHours += lc.hours;
      totalRate += lc.rate;
    }

    setState(() {
      _nonBillableHours = totalHours * 0.1;
      _nonBillableRate = totalCosts == 0 ? 0.0 : totalRate / totalCosts;
    });
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    hoursController.dispose();
    rateController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _updateNonBillableValues();
    selected = List.generate(
        _costsEstimatorService.laborCosts.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    List<DataColumn> _materialCostsColumns = const <DataColumn>[
      DataColumn(
        label: Text(
          'Name',
          style: TextStyle(fontSize: 12),
        ),
      ),
      DataColumn(
        label: Text(
          'Hours',
          style: TextStyle(fontSize: 12),
        ),
        numeric: true,
      ),
      DataColumn(
        label: Text(
          'Rate',
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
            _costsEstimatorService.laborCosts.length,
            (int index) => DataRow(
              color: _getColorByIndex(index),
              cells: _generateDataRow(_costsEstimatorService.laborCosts[index])
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
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const Text(
              'Non billable ratio (10%)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const Spacer(),
            Text(_nonBillableHours.toStringAsFixed(2)),
            const SizedBox(width: 20),
            Text(_nonBillableRate.toStringAsFixed(2)),
            const SizedBox(width: 20),
          ],
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
