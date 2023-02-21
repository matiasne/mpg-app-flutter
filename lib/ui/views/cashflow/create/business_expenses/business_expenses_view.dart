import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/widgets/subtitle.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:mpg_mobile/viewmodels/cashflow/create/business_expenses/business_expenses_viewmodel.dart';
import 'package:stacked/stacked.dart';

class BusinessExpensesView extends StatelessWidget {
  const BusinessExpensesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BusinessExpensesViewModel>.reactive(
      builder: (context, model, child) => Column(
        children: [
          const Subtitle(title: 'Business Expenses'),
          const SizedBox(
            height: 10,
          ),
          const Text(
              'Enter all related business expenses that are weekly, bi-weekly or monthly'),
          AppTable(
            columns: model.columns,
            rows: model.rows,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                  onPressed: model.onAdd,
                  icon: const Icon(Icons.add),
                  label: const Text('Add')),
            ],
          )
        ],
      ),
      viewModelBuilder: () => BusinessExpensesViewModel(),
    );
  }
}
