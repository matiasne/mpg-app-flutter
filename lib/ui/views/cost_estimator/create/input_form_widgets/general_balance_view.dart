import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mpg_mobile/constants/utils.dart';
import 'package:mpg_mobile/viewmodels/cost_estimator/create/general_balance_viewmodel.dart';
import 'package:stacked/stacked.dart';

class GeneralBalanceView extends StatelessWidget {
  final Function next;
  final Function? back;
  const GeneralBalanceView({Key? key, required this.next, this.back})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GeneralBalanceViewModel>.reactive(
      builder: (context, model, child) => Form(
        key: model.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(model.headerText,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            TextFormField(
              controller: model.revenueController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(doubleRegex),
              ],
              decoration: InputDecoration(
                  labelText: 'Annual Revenue',
                  helperText: model.helperTextRevenue,
                  prefix: const Text('\$')),
            ),
            TextFormField(
              controller: model.costController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(doubleRegex),
              ],
              decoration: InputDecoration(
                labelText: 'Annual COGS',
                helperText: model.helperTextCosts,
                prefix: const Text('\$'),
              ),
              onChanged: (text) => model.onRatioChanged(),
            ),
            TextFormField(
              controller: model.expensesController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(doubleRegex),
              ],
              decoration: InputDecoration(
                labelText: 'Annual Fixed Expenses',
                helperText: model.helperTextFixedCosts,
                prefix: const Text('\$'),
              ),
              onChanged: (text) => model.onRatioChanged(),
            ),
            TextFormField(
              controller: model.ratioController,
              decoration: const InputDecoration(labelText: 'Overhead Ratio'),
              readOnly: true,
            ),
            ButtonBar(
              alignment: MainAxisAlignment.start,
              buttonPadding: const EdgeInsets.all(20),
              children: [
                if (back != null)
                  TextButton(
                    onPressed: () => {back!()},
                    child: const Text('Back'),
                  ),
                ElevatedButton(
                  onPressed: () => next(),
                  child: const Text('Next'),
                )
              ],
            )
          ],
        ),
      ),
      viewModelBuilder: () => GeneralBalanceViewModel(),
    );
  }
}
