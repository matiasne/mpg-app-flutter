import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:mpg_mobile/ui/widgets/text_field.dart';
import 'package:mpg_mobile/viewmodels/business_valuation/detail/projections/projection_inputs_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ProjectionInputsView extends StatelessWidget {
  const ProjectionInputsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProjectionInputsViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) => Column(
        children: [
          AppTextField(
            label: 'Cost Of Goods Sold (COGS)',
            controller: model.costOfGoodsSoldController,
            onChanged: model.onCogsChanged,
            prefix: const Text('\$'),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: AppTable(columns: model.columns, rows: model.rows),
          ),
        ],
      ),
      viewModelBuilder: () => ProjectionInputsViewModel(),
    );
  }
}
