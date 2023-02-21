import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/widgets/subtitle.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:mpg_mobile/viewmodels/cashflow/create/debt_services/debt_services_viewmodel.dart';
import 'package:stacked/stacked.dart';

class DebtServicesView extends StatelessWidget {
  const DebtServicesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DebtServicesViewModel>.reactive(
      builder: (context, model, child) => Column(
        children: [
          const Subtitle(title: 'Debt Services'),
          const SizedBox(
            height: 10,
          ),
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
      viewModelBuilder: () => DebtServicesViewModel(),
    );
  }
}
