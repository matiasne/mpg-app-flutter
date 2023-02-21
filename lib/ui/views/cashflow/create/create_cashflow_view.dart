import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mpg_mobile/constants/utils.dart';
import 'package:mpg_mobile/ui/views/cashflow/create/account_payables/account_payables_view.dart';
import 'package:mpg_mobile/ui/views/cashflow/create/account_receivables/account_receivables_view.dart';
import 'package:mpg_mobile/ui/views/cashflow/create/borrowings/borrowings_view.dart';
import 'package:mpg_mobile/ui/views/cashflow/create/business_expenses/business_expenses_view.dart';
import 'package:mpg_mobile/ui/views/cashflow/create/debt_services/debt_services_view.dart';
import 'package:mpg_mobile/ui/views/cashflow/create/one_time_effects/one_time_effects_view.dart';
import 'package:mpg_mobile/ui/views/cashflow/create/recurring_income/recurring_income_view.dart';
import 'package:mpg_mobile/ui/widgets/error_message.dart';
import 'package:mpg_mobile/ui/widgets/form_button.dart';
import 'package:mpg_mobile/ui/widgets/form_field.dart';
import 'package:mpg_mobile/ui/widgets/loading_button.dart';
import 'package:mpg_mobile/viewmodels/cashflow/create/create_cashflow_viewmodel.dart';
import 'package:stacked/stacked.dart';

class CreateCashFlowView extends StatelessWidget {
  const CreateCashFlowView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateCashFlowViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(),
      onDispose: (model) => model.onDispose(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Create Cash Flow'),
          leading: BackButton(
            onPressed: model.goBack,
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppFormField(
                  label: 'Business name',
                  controller: model.nameController,
                ),
                AppFormField(
                  controller: model.startDateController,
                  label: "Start date",
                  onTap: () async {
                    DateTime? date = DateTime(1900);
                    FocusScope.of(context).requestFocus(FocusNode());
                    date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100));

                    model.setStartDate(date);
                  },
                ),
                AppFormField(
                  label: 'Business Checking Account',
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(doubleRegex),
                  ],
                  prefix: const Text('\$'),
                  controller: model.checkingAccountController,
                ),
                AppFormField(
                    label: 'Payroll Account',
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(doubleRegex),
                    ],
                    prefix: const Text('\$'),
                    controller: model.payrollAccountController),
                AppFormField(
                  label: 'Savings Account',
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(doubleRegex),
                  ],
                  prefix: const Text('\$'),
                  controller: model.savingsAccountController,
                ),
                const SizedBox(height: 20),
                Card(
                  child: Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      padding: const EdgeInsets.all(20),
                      child: const RecurringIncomeView()),
                ),
                const SizedBox(height: 20),
                Card(
                    child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  padding: const EdgeInsets.all(20),
                  child: const AccountReceivablesView(),
                )),
                const SizedBox(height: 20),
                Card(
                    child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  padding: const EdgeInsets.all(20),
                  child: const BusinessExpensesView(),
                )),
                const SizedBox(height: 20),
                Card(
                    child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  padding: const EdgeInsets.all(20),
                  child: const OneTimeEffectsView(),
                )),
                const SizedBox(height: 20),
                Card(
                    child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  padding: const EdgeInsets.all(20),
                  child: const DebtServicesView(),
                )),
                Card(
                    child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  padding: const EdgeInsets.all(20),
                  child: const AccountPayablesView(),
                )),
                const BorrowingsView(),
                if (model.errorMsg.isNotEmpty)
                  ErrorMessage(message: model.errorMsg),
                model.isBusy
                    ? const LoadingButton()
                    : AppFormButton(
                        child: const Text('Create'),
                        onPressed: model.onSubmit,
                      ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => CreateCashFlowViewModel(),
    );
  }
}
