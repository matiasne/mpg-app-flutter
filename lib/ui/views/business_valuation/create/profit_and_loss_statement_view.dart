import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mpg_mobile/constants/utils.dart';
import 'package:mpg_mobile/extensions/input_formatter_extensions.dart';
import 'package:mpg_mobile/ui/widgets/form_field.dart';
import 'package:mpg_mobile/ui/widgets/subtitle.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:mpg_mobile/viewmodels/business_valuation/create/profit_and_loss_statement_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ProfitAndLossStatementView extends StatelessWidget {
  const ProfitAndLossStatementView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfitAndLossStatementViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) {
        model.rebuildTable();
        return Column(
          children: [
            const Subtitle(title: 'Profit & Loss statement'),
            AppFormField(
              label: 'Cost of goods sold',
              onChanged: model.onCOGSChanged,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(priceRegex),
                PriceFormatter(),
              ],
              prefix: const Text('\$'),
            ),
            AppTable(
              columns: model.columns,
              rows: model.rows,
            ),
          ],
        );
      },
      viewModelBuilder: () => ProfitAndLossStatementViewModel(),
    );
  }
}
