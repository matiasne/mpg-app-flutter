import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/views/cost_estimator/details/estimate_sheet/profit_view.dart';
import 'package:mpg_mobile/ui/widgets/subtitle.dart';
import 'package:mpg_mobile/viewmodels/cost_estimator/details/estimate_sheet_details_viewmodel.dart';
import 'package:stacked/stacked.dart';

import 'labor_tracker_view.dart';
import 'material_cost_view.dart';
import 'metrics_view.dart';

class EstimateSheetDetialsView extends StatelessWidget {
  const EstimateSheetDetialsView({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EstimateSheetDetialsViewModel>.reactive(
      builder: (context, model, child) => SingleChildScrollView(
        child: Column(
          children: const [
            Subtitle(title: 'Parts & Supply'),
            MaterialCostView(),
            Subtitle(title: 'Labor'),
            LaborTrackerView(),
            Subtitle(title: 'Metrics'),
            MetricsView(),
            Subtitle(title: 'Profit table'),
            ProfitView(),
          ],
        ),
      ),
      viewModelBuilder: () => EstimateSheetDetialsViewModel(),
    );
  }
}
