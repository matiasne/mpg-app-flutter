import 'package:flutter/material.dart';
import 'package:mpg_mobile/viewmodels/cost_estimator/create/costs_viewmodel.dart';
import 'package:stacked/stacked.dart';

import 'costs/labor_costs_table/labor_costs_table.dart';
import 'costs/material_costs_table/material_costs_table.dart';

class CostsFormView extends StatelessWidget {
  final void Function() next;
  final Function back;
  const CostsFormView({
    Key? key,
    required this.next,
    required this.back,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CostsFormViewModel>.reactive(
      builder: (context, model, child) => Column(
        children: [
          const MaterialCostsTable(),
          const LaborCostsTable(),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            buttonPadding: const EdgeInsets.all(20),
            children: [
              TextButton(
                onPressed: () => {back()},
                child: const Text('Back'),
              ),
              ElevatedButton(
                onPressed: () {
                  next();
                },
                child: const Text('Next'),
              )
            ],
          )
        ],
      ),
      viewModelBuilder: () => CostsFormViewModel(),
    );
  }
}
