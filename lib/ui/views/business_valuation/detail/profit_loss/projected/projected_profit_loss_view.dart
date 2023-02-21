import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/widgets/metric_card.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:mpg_mobile/util/formatters.dart';
import 'package:mpg_mobile/viewmodels/business_valuation/detail/profit_loss/projected/projected_profit_loss_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ProjectedProfitLossView extends StatelessWidget {
  const ProjectedProfitLossView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProjectedProfitLossViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) => SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MetricCard(
                        title: 'Initial Valuation',
                        value:
                            '\$${Formatters.toPrice(model.initialValuation.toStringAsFixed(2))}',
                      ),
                      if (!model.isBusy)
                        MetricCard(
                          highlight: true,
                          title: 'Revised Valuation',
                          value:
                              '\$${Formatters.toPrice(model.revisedValuation.toStringAsFixed(2))}',
                        ),
                      if (!model.isBusy)
                        MetricCard(
                          title: 'The Difference',
                          value:
                              '\$${Formatters.toPrice(model.difference.toStringAsFixed(2))}',
                        ),
                    ],
                  ),
                ),
              ),
              model.isBusy
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child:
                          AppTable(columns: model.columns, rows: model.rows)),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => ProjectedProfitLossViewModel(),
    );
  }
}
