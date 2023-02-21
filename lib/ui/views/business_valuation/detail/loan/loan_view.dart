import 'package:flutter/material.dart';
import 'package:mpg_mobile/models/loan.dart';
import 'package:mpg_mobile/ui/views/business_valuation/detail/loan/amortization_schedule_view.dart';
import 'package:mpg_mobile/viewmodels/business_valuation/detail/loan/loan_viewmodel.dart';
import 'package:stacked/stacked.dart';

import 'loan_summary_view.dart';

class LoanView extends StatelessWidget {
  const LoanView({Key? key, required this.loan}) : super(key: key);
  final Loan? loan;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoanViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(loan: loan),
      onDispose: (model) => model.onDispose(),
      builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text('Loan Calculator'),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: const [
                  LoanSummaryView(),
                  AmortizationScheduleView(),
                ],
              ),
            ),
          )),
      viewModelBuilder: () => LoanViewModel(),
    );
  }
}
