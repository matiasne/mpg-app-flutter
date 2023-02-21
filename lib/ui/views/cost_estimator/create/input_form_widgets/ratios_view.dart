import 'package:flutter/material.dart';
import 'package:mpg_mobile/viewmodels/cost_estimator/create/costs_viewmodel.dart';
import 'package:stacked/stacked.dart';

import 'costs/costs_ratios_form/costs_ratios_form.dart';

class RatiosView extends StatelessWidget {
  final void Function() next;
  final Function back;
  const RatiosView({
    Key? key,
    required this.next,
    required this.back,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CostsFormViewModel>.reactive(
      builder: (context, model, child) => Column(
        children: [
          const CostsRatiosForm(),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            buttonPadding: const EdgeInsets.all(20),
            children: [
              TextButton(
                onPressed: () => {back()},
                child: const Text('Back'),
              ),
              ElevatedButton(
                onPressed: () {
                  next();
                },
                child: const Text('Next'),
              )
            ],
          )
        ],
      ),
      viewModelBuilder: () => CostsFormViewModel(),
    );
  }
}
