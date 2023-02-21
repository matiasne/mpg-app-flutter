import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/widgets/subtitle.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:mpg_mobile/viewmodels/business_valuation/create/metrics_table_viewmodel.dart';
import 'package:stacked/stacked.dart';

class MetricsTableView extends StatelessWidget {
  const MetricsTableView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MetricsTableViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) => Column(
        children: [
          const Subtitle(title: 'Financtial Numbers'),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: AppTable(
              columns: model.columns,
              rows: model.rows,
            ),
          ),
        ],
      ),
      viewModelBuilder: () => MetricsTableViewModel(),
    );
  }
}
