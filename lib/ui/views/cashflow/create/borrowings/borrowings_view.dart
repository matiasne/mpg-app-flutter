import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mpg_mobile/constants/utils.dart';
import 'package:mpg_mobile/ui/widgets/form_field.dart';
import 'package:mpg_mobile/ui/widgets/subtitle.dart';
import 'package:mpg_mobile/viewmodels/cashflow/create/borrowings/borrowings_viewmodel.dart';
import 'package:stacked/stacked.dart';

class BorrowingsView extends StatelessWidget {
  const BorrowingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BorrowingsViewModel>.reactive(
      builder: (context, model, child) => Form(
          child: Column(
        children: [
          const Subtitle(title: 'LOC Borrowings'),
          AppFormField(
            label: 'Savings',
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(doubleRegex),
            ],
            prefix: const Text('\$'),
            controller: model.savingsController,
          ),
          AppFormField(
            label: 'Total LOCs',
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(doubleRegex),
            ],
            prefix: const Text('\$'),
            controller: model.locsController,
          ),
          AppFormField(
            label: 'Outstanding Draws',
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(doubleRegex),
            ],
            prefix: const Text('\$'),
            controller: model.outstandingDrawsController,
          ),
          AppFormField(
            label: 'Other Savings',
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(doubleRegex),
            ],
            prefix: const Text('\$'),
            controller: model.otherSavingsController,
          ),
        ],
      )),
      viewModelBuilder: () => BorrowingsViewModel(),
    );
  }
}
