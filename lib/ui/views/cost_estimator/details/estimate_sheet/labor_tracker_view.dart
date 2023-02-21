import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:mpg_mobile/viewmodels/cost_estimator/details/estimate_sheet/labor_tracker_viewmodel.dart';
import 'package:stacked/stacked.dart';

class LaborTrackerView extends StatelessWidget {
  const LaborTrackerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LaborTrackerViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) => Column(
        children: [
          AppTable(columns: model.columns, rows: model.rows),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: AppTable(
                  columns: model.laborBurdenColumns,
                  rows: model.laborBurdenRows)),
          AppTable(
              columns: model.fringeRateColumns, rows: model.fringeRateRows),
        ],
      ),
      viewModelBuilder: () => LaborTrackerViewModel(),
    );
  }
}
