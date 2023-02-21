import 'package:flutter/material.dart';
import 'package:mpg_mobile/constants/route_names.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/services/navigation_service.dart';
import 'package:mpg_mobile/services/ui/cost_estimator/cost_estinator_input_form.service.dart';
import 'package:mpg_mobile/ui/views/cost_estimator/create/input_form_widgets/ratios_view.dart';

import 'input_form_widgets/client_information_view.dart';
import 'input_form_widgets/costs_view.dart';
import 'input_form_widgets/general_balance_view.dart';
import 'input_form_widgets/proposal_sheet_view.dart';

class CostEstimatorInputForm extends StatefulWidget {
  const CostEstimatorInputForm({Key? key}) : super(key: key);

  @override
  _CostEstimatorInputFormState createState() => _CostEstimatorInputFormState();
}

class _CostEstimatorInputFormState extends State<CostEstimatorInputForm> {
  final _costEstimatorService = locator<CostEstimatorFormService>();
  final _navigatorService = locator<NavigationService>();

  int _currentStep = 0;
  List<Step> get steps => [
        Step(
            title: const Text('Client information'),
            content: ClientInformationView(
              next: next,
            )),
        Step(
            title: const Text('General Balance'),
            content: GeneralBalanceView(
              next: next,
              back: back,
            )),
        Step(
            title: const Text('Costs'),
            content: CostsFormView(
              next: next,
              back: back,
            )),
        Step(
            title: const Text('Ratios'),
            content: RatiosView(
              next: next,
              back: back,
            )),
        Step(
            title: const Text('Proposal'),
            content: ProposalSheetView(
              onSubmit: onSubmit,
              back: back,
            )),
      ];

  void next() {
    _currentStep < steps.length - 1 ? setState(() => _currentStep += 1) : null;
  }

  Future<void> onSubmit() async {
    try {
      await _costEstimatorService.submitForm();
      _navigatorService.popAndPushNamed(costEstimatorRoute);
    } catch (e) {
      rethrow;
    }
  }

  back() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Project Cost Estimation'),
        leading: BackButton(
          onPressed: () =>
              _navigatorService.popAndPushNamed(costEstimatorRoute),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
            ),
            child: Stepper(
              physics: const NeverScrollableScrollPhysics(),
              controlsBuilder: (context, details) => Container(),
              currentStep: _currentStep,
              steps: steps,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _costEstimatorService.dispose();
    super.dispose();
  }
}
