import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/widgets/form_select_field.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:mpg_mobile/viewmodels/cashflow/detail/forecast/forecast_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ForecastView extends StatelessWidget {
  ForecastView({Key? key}) : super(key: key);

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForecastViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              AppFormSelectField(
                  label: 'Forecast Type',
                  items: model.tableTypes,
                  onChanged: model.setTableType,
                  value: model.tableType),
              AppFormSelectField(
                  label: 'Weeks to project',
                  items: model.weeks,
                  onChanged: model.setWeeksToProject,
                  value: model.weeksToProject),
              Scrollbar(
                controller: _scrollController,
                isAlwaysShown: true,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 40),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: AppTable(
                      columns: model.columns,
                      rows: model.rows,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
      viewModelBuilder: () => ForecastViewModel(),
    );
  }
}
