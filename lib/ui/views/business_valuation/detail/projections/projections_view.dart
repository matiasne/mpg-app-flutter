import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/views/business_valuation/detail/projections/projection_inputs_view.dart';
import 'package:mpg_mobile/ui/views/business_valuation/detail/projections/projection_results_view.dart';
import 'package:mpg_mobile/ui/widgets/info_message.dart';
import 'package:mpg_mobile/viewmodels/business_valuation/detail/projections/projections_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ProjectionsView extends StatelessWidget {
  const ProjectionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProjectionsViewModel>.reactive(
      builder: (context, model, child) => SingleChildScrollView(
        child: Column(
          children: const [
            InfoMessage(
                message:
                    'ENTERING YOUR ACTUAL FINANCIAL NUMBERS CREATES AN ACCURATE FINANCIAL PICTURE OF WHAT YOUR BUSINESS VALUE LOOKS LIKE!\n\n'
                    'Step 1. Enter actual revenue and net profits into the input box (sellers discretionary income is optional).\n\n'
                    'Step 2. Enter projected or estimated growth percentages for both revenue and net profits (again SDI is optional).\n\n'
                    'Step 3. Enter annual Cost of Goods Sold (COGS dollars) into input box.'),
            ProjectionInputsView(),
            ProjectionResultsView(),
          ],
        ),
      ),
      viewModelBuilder: () => ProjectionsViewModel(),
    );
  }
}
