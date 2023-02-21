import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/widgets/metric_card.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:mpg_mobile/util/formatters.dart';
import 'package:mpg_mobile/viewmodels/business_valuation/detail/valuation_ranking/ranking_results_viewmodel.dart';
import 'package:stacked/stacked.dart';

class RankingResultsView extends StatelessWidget {
  const RankingResultsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RankingResultsViewModel>.reactive(
      builder: (context, model, child) {
        List<AppTableRow> rows = model.buildTable();
        return Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: AppTable(columns: model.columns, rows: rows),
            ),
            MetricCard(
                title: 'Average Estimated Company Value',
                value: '\$${Formatters.toPrice(model.averageEstimatedValue.toStringAsFixed(2))}'),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      },
      viewModelBuilder: () => RankingResultsViewModel(),
    );
  }
}
