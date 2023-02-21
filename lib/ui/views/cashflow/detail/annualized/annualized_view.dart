import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/widgets/metric_card.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:mpg_mobile/util/formatters.dart';
import 'package:mpg_mobile/viewmodels/cashflow/detail/annualized/annualized_viewmodel.dart';
import 'package:stacked/stacked.dart';

class AnnualizedView extends StatelessWidget {
  const AnnualizedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AnnualizedViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) => SingleChildScrollView(
        child: Column(
          children: [
            // recurring effects table
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: AppTable(
                columns: model.recurringColumns,
                rows: model.recurringRows,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // one time effects table
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: AppTable(
                columns: model.oneTimeColumns,
                rows: model.oneTimeRows,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            MetricCard(
                title: 'Total Current',
                value:
                    '\$${Formatters.toPrice(model.totalCurrent.toString())}'),
          ],
        ),
      ),
      viewModelBuilder: () => AnnualizedViewModel(),
    );
  }
}
