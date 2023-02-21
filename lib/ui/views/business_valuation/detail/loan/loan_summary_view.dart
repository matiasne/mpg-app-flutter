import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mpg_mobile/constants/utils.dart';
import 'package:mpg_mobile/util/formatters.dart';
import 'package:mpg_mobile/viewmodels/business_valuation/detail/loan/loan_summary_viewmodel.dart';
import 'package:stacked/stacked.dart';

class LoanSummaryView extends StatelessWidget {
  const LoanSummaryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const valueStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);

    return ViewModelBuilder<LoanSummaryViewModel>.reactive(
      builder: (context, model, child) => Center(
        child: Column(
          children: [
            Card(
              child: Container(
                padding: const EdgeInsets.all(20),
                constraints: const BoxConstraints(maxWidth: 300),
                child: Column(
                  children: [
                    const Text('Purchase amount'),
                    Text(
                      '\$ ${Formatters.toPrice(model.loan.loanAmount.toStringAsFixed(2))}',
                      style: valueStyle,
                    ),
                    const Divider(),
                    const Text('Initial Equity Payment'),
                    Text(
                      '\$ ${Formatters.toPrice(model.loan.downPayment.toStringAsFixed(2))}',
                      style: valueStyle,
                    ),
                    const Divider(),
                    const Text('Loan Amount'),
                    Text(
                      '\$ ${Formatters.toPrice(model.loan.amount.toStringAsFixed(2))}',
                      style: valueStyle,
                    ),
                    const Divider(),
                    const Text('Interest Rate'),
                    TextField(
                      textAlign: TextAlign.center,
                      style: valueStyle,
                      onChanged: model.onInterestChanged,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(doubleRegex),
                      ],
                      decoration: const InputDecoration(
                        hintText: 'Set interest rate',
                        suffix: Text('%'),
                        suffixStyle: valueStyle,
                      ),
                    ),
                    const Divider(),
                    const Text('Amortization Period'),
                    Text(
                      '${model.loan.numberOfYears} years',
                      style: valueStyle,
                    ),
                    const Divider(),
                    const Text('Loan term'),
                    Text(
                      '${model.loan.numberOfYears} years',
                      style: valueStyle,
                    ),
                    const Divider(),
                    const Text('Loan start date'),
                    Text(
                      dateFormat.format(model.loan.startDate),
                      style: valueStyle,
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Container(
                padding: const EdgeInsets.only(left:20, right: 20, top: 10, bottom: 10),
                constraints: const BoxConstraints(minWidth: 300, maxWidth: 300),
                child: DropdownButton<String>(
                  value: model.frequency,
                  hint: Text(model.frequency),
                  items: model.frequencies.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: model.onFrequencyChanged,
                ),
              ),
            ),
            Card(
              child: Container(
                padding: const EdgeInsets.all(20),
                constraints: const BoxConstraints(maxWidth: 300),
                child: Column(children: [
                  Text('${model.frequency} Payment'),
                  Text(
                    '\$${Formatters.toPrice(model.monthlyPayment.toStringAsFixed(2))}',
                    style: valueStyle,
                  ),
                  const Divider(),
                  const Text('Annual Payment'),
                  Text(
                    '\$${Formatters.toPrice(model.annualPayment.toStringAsFixed(2))}',
                    style: valueStyle,
                  ),
                  const Divider(),
                ]),
              ),
            ),
          ],
        ),
      ),
      viewModelBuilder: () => LoanSummaryViewModel(),
    );
  }
}
