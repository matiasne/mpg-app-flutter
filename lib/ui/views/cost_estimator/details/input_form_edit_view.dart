import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/views/cost_estimator/create/input_form_widgets/costs_view.dart';
import 'package:mpg_mobile/ui/views/cost_estimator/create/input_form_widgets/general_balance_view.dart';
import 'package:mpg_mobile/ui/views/cost_estimator/create/input_form_widgets/proposal_sheet_view.dart';
import 'package:mpg_mobile/viewmodels/cost_estimator/details/input_form_edit_viewmodel.dart';
import 'package:stacked/stacked.dart';

class InputFormEditView extends StatelessWidget {
  const InputFormEditView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InputFormEditViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(),
      onDispose: (model) => model.onDispose(),
      builder: (context, model, child) {
        double maxWidth = 600;

        List<Step> steps = [
          Step(
            title: const Text('General Balance'),
            content: GeneralBalanceView(
              next: model.next,
              back: model.back,
            ),
          ),
          Step(
            title: const Text('Costs'),
            content: CostsFormView(
              next: model.next,
              back: model.back,
            ),
          ),
          Step(
            title: const Text('Proposal'),
            content: ProposalSheetView(
              onSubmit: model.onSubmit,
              back: model.back,
            ),
          ),
        ];

        return Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
            ),
            child: SingleChildScrollView(
              child: Stepper(
                physics: const ClampingScrollPhysics(),
                onStepTapped: model.onStepTapped,
                controlsBuilder: (context, details) => Container(),
                currentStep: model.currentStep,
                steps: steps,
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => InputFormEditViewModel(),
    );
  }
}
