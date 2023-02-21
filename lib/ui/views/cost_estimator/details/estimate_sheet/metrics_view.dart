import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:mpg_mobile/viewmodels/cost_estimator/details/estimate_sheet/metrics_viewmodel.dart';
import 'package:stacked/stacked.dart';

class MetricsView extends StatelessWidget {
  const MetricsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MetricsViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: AppTable(columns: model.columns, rows: model.rows)),
      viewModelBuilder: () => MetricsViewModel(),
    );
  }
}
