import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/widgets/metric_card.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:mpg_mobile/viewmodels/business_valuation/detail/valuation_ranking/ranking_inputs_viewmodel.dart';
import 'package:stacked/stacked.dart';

class RankingInputsView extends StatelessWidget {
  const RankingInputsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RankingInputsViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) => Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: AppTable(columns: model.columns, rows: model.rows),
          ),
          MetricCard(
            title: 'Score Rate (max score: 7)',
            value: '${model.scoreRate.toStringAsFixed(2)} %',
          ),
        ],
      ),
      viewModelBuilder: () => RankingInputsViewModel(),
    );
  }
}
