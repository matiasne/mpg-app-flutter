import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:mpg_mobile/viewmodels/business_valuation/detail/loan/amortization_schedule_viewmodel.dart';
import 'package:stacked/stacked.dart';

class AmortizationScheduleView extends StatelessWidget {
  const AmortizationScheduleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AmortizationScheduleViewModel>.reactive(
      builder: (context, model, child) => Center(
        child: Container(
          constraints: const BoxConstraints(
            maxHeight: 400,
          ),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: AppTable(
                columns: model.columns,
                rows: model.rows,
              ),
            ),
          ),
        ),
      ),
      viewModelBuilder: () => AmortizationScheduleViewModel(),
    );
  }
}
