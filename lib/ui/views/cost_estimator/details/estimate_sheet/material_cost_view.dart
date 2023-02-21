import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:mpg_mobile/viewmodels/cost_estimator/details/estimate_sheet/material_costs_viewmodel.dart';
import 'package:stacked/stacked.dart';

class MaterialCostView extends StatelessWidget {
  const MaterialCostView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MaterialCostViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) => AppTable(
        columns: model.columns,
        rows: model.rows,
      ),
      viewModelBuilder: () => MaterialCostViewModel(),
    );
  }
}
