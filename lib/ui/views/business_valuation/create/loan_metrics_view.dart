import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mpg_mobile/constants/utils.dart';
import 'package:mpg_mobile/extensions/input_formatter_extensions.dart';
import 'package:mpg_mobile/ui/widgets/form_date_field.dart';
import 'package:mpg_mobile/ui/widgets/subtitle.dart';
import 'package:mpg_mobile/ui/widgets/text_field.dart';
import 'package:mpg_mobile/viewmodels/business_valuation/create/loan_metrics_viewmodel.dart';
import 'package:stacked/stacked.dart';

class LoanMetricsView extends StatelessWidget {
  const LoanMetricsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoanMetricsViewModel>.reactive(
      builder: (context, model, child) => Column(
        children: [
          const Subtitle(title: 'Loan Numbers if applicable'),
          AppTextField(
            label: 'Number of Years',
            suffix: const Text('years'),
            controller: model.yearsController,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(intRegex),
            ],
          ),
          AppTextField(
            label: 'Amount',
            controller: model.amountController,
            prefix: const Text('\$'),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(priceRegex),
              PriceFormatter(),
            ],
          ),
          AppTextField(
            label: 'Down payment',
            prefix: const Text('\$'),
            controller: model.downPaymentController,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(priceRegex),
              PriceFormatter(),
            ],
          ),
          AppDateField(
            controller: model.loanStartDateController,
            label: "Loan start date",
            onChanged: model.setLoanStartDate,
          ),
        ],
      ),
      viewModelBuilder: () => LoanMetricsViewModel(),
    );
  }
}
