import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/widgets/subtitle.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:mpg_mobile/viewmodels/cashflow/create/account_payables/account_payables_viewmodel.dart';
import 'package:stacked/stacked.dart';

class AccountPayablesView extends StatelessWidget {
  const AccountPayablesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AccountPayablesViewModel>.reactive(
      builder: (context, model, child) => Column(
        children: [
          const Subtitle(title: 'Account Payables'),
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
      viewModelBuilder: () => AccountPayablesViewModel(),
    );
  }
}
