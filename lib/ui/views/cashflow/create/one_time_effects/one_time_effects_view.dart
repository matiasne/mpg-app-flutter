import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/widgets/subtitle.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:mpg_mobile/viewmodels/cashflow/create/one_time_effects/one_time_effects_viewmodel.dart';
import 'package:stacked/stacked.dart';

class OneTimeEffectsView extends StatelessWidget {
  const OneTimeEffectsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OneTimeEffectsViewModel>.reactive(
      builder: (context, model, child) => Column(
        children: [
          const Subtitle(title: 'Change Impact One Time Effects'),
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
      viewModelBuilder: () => OneTimeEffectsViewModel(),
    );
  }
}
