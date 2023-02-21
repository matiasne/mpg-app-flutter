import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:mpg_mobile/viewmodels/cost_estimator/details/estimate_sheet/profit_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ProfitView extends StatelessWidget {
  const ProfitView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfitViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: AppTable(
          columns: model.columns,
          rows: model.rows,
        ),
      ),
      viewModelBuilder: () => ProfitViewModel(),
    );
  }
}
