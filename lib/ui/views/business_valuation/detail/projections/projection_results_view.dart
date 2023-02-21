import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/widgets/form_select_field.dart';
import 'package:mpg_mobile/ui/widgets/metric_card.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:mpg_mobile/util/formatters.dart';
import 'package:mpg_mobile/viewmodels/business_valuation/detail/projections/projections_result_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ProjectionResultsView extends StatelessWidget {
  const ProjectionResultsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProjectionResultsViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) {
        List<AppTableRow> rows = model.buildTable();
        return Column(
          children: [
            AppFormSelectField(
                label: 'Years to project',
                items: model.years,
                onChanged: model.setYearsToProject,
                value: model.yearsToProject),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: AppTable(
                columns: model.columns,
                rows: rows,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MetricCard(
                    title: 'Average Company Estimated \nValue',
                    value: model.averageEstimatedValue.isNaN
                        ? '-'
                        : '\$${Formatters.toPrice(model.averageEstimatedValue.toStringAsFixed(2))}',
                  ),
                  MetricCard(
                    title:
                        'Average Company Estimated Value \n(including net income)',
                    value: model.averageEstimatedValueWithNetIncome.isNaN
                        ? '-'
                        : '\$${Formatters.toPrice(model.averageEstimatedValueWithNetIncome.toStringAsFixed(2))}',
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      },
      viewModelBuilder: () => ProjectionResultsViewModel(),
    );
  }
}
