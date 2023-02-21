import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/widgets/subtitle.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:mpg_mobile/viewmodels/business_valuation/create/non_financtial_indicators_viewmodel.dart';
import 'package:stacked/stacked.dart';

class NonFinanctialIndicatorsView extends StatelessWidget {
  const NonFinanctialIndicatorsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NonFinanctialIndicatorsViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) {
        return Column(
          children: [
            const Subtitle(title: 'Key non-financtual indicators'),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: AppTable(columns: model.columns, rows: model.rows)),
          ],
        );
      },
      viewModelBuilder: () => NonFinanctialIndicatorsViewModel(),
    );
  }
}
