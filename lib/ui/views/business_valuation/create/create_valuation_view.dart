import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/views/business_valuation/create/metrics_table_view.dart';
import 'package:mpg_mobile/ui/views/business_valuation/create/non_financtial_indicators_view.dart';
import 'package:mpg_mobile/ui/views/business_valuation/create/profit_and_loss_statement_view.dart';
import 'package:mpg_mobile/ui/widgets/error_message.dart';
import 'package:mpg_mobile/ui/widgets/form_button.dart';
import 'package:mpg_mobile/ui/widgets/form_field.dart';
import 'package:mpg_mobile/ui/widgets/loading_button.dart';
import 'package:mpg_mobile/util/validators.dart';
import 'package:mpg_mobile/viewmodels/business_valuation/create/create_valuation_viewmodel.dart';
import 'package:stacked/stacked.dart';

import 'loan_metrics_view.dart';

class CreateValuationView extends StatelessWidget {
  const CreateValuationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateValuationViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(),
      onDispose: (model) => model.onDispose(),
      builder: (context, model, child) {

        Widget submitButton = model.isBusy
            ? const LoadingButton()
            : AppFormButton(
                child: const Text('Create'),
                onPressed: model.onSubmit,
              );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Create Business Valuation'),
            leading: BackButton(
              onPressed: model.goBack,
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Form(
                key: model.formKey,
                child: Column(
                  children: [
                    AppFormField(
                      label: 'Perspective Business',
                      controller: model.nameController,
                      validator: vRequired,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 20),
                    const MetricsTableView(),
                    const SizedBox(height: 20),
                    const ProfitAndLossStatementView(),
                    const SizedBox(height: 20),
                    const NonFinanctialIndicatorsView(),
                    const SizedBox(height: 20),
                    TextButton(
                      child:
                          model.addLoan ? const Text('Remove Loan') : const Text('Add Loan'),
                      onPressed: model.toggleLoan,
                    ),
                    if (model.addLoan) const LoanMetricsView(),
                    if (model.addLoan) const SizedBox(height: 20),
                    if (model.errorMsg.isNotEmpty) ErrorMessage(message: model.errorMsg),
                    submitButton
                  ],
                ),
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => CreateValuationViewModel(),
    );
  }
}
