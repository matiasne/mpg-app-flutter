import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/services/ui/cost_estimator/cost_estinator_input_form.service.dart';

class CostsRatiosForm extends StatefulWidget {
  const CostsRatiosForm({Key? key}) : super(key: key);

  @override
  _CostsRatiosFormState createState() => _CostsRatiosFormState();
}

class _CostsRatiosFormState extends State<CostsRatiosForm> {
  final _formKey = GlobalKey<FormState>();
  final _costsEstimatorService = locator<CostEstimatorFormService>();

  final _doubleRegex = RegExp(r'^[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)$');

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            controller: _costsEstimatorService.taxRatioController,
            decoration: const InputDecoration(
              labelText: 'Tax ratio',
              helperText: 'Enter Labor Burden Ratio',
              suffix: Text('%'),
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(_doubleRegex),
            ],
          ),
          TextFormField(
            controller: _costsEstimatorService.fringeRateController,
            decoration: const InputDecoration(
              labelText: 'Fringe rate',
              prefix: Text('\$'),
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(_doubleRegex),
            ],
          ),
          TextFormField(
            controller: _costsEstimatorService.contingencyRatioController,
            decoration: const InputDecoration(
              labelText: 'Contingency',
              helperText: 'Enter Contingency Ratio',
              suffix: Text('%'),
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(_doubleRegex),
            ],
          ),
          TextFormField(
            controller: _costsEstimatorService.salesComissionController,
            decoration: const InputDecoration(
              labelText: 'Sales Comission',
              helperText: 'Enter Sales Comission Ratio',
              suffix: Text('%'),
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(_doubleRegex),
            ],
          ),
          TextFormField(
            controller: _costsEstimatorService.desiredProfitController,
            decoration: const InputDecoration(
              labelText: 'Desired Profit',
              helperText: 'Enter Desired Profit Ratio',
              suffix: Text('%'),
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(_doubleRegex),
            ],
          ),
          TextFormField(
            controller: _costsEstimatorService.squareFeetController,
            decoration: const InputDecoration(
              labelText: 'Square Feet',
              helperText: 'Enter Number of Square Feet',
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(_doubleRegex),
            ],
          ),
        ],
      ),
    );
  }
}
