import 'package:flutter/material.dart';
import 'package:mpg_mobile/constants/dimensions.dart';
import 'package:mpg_mobile/constants/utils.dart';
import 'package:mpg_mobile/ui/widgets/form_button.dart';
import 'package:mpg_mobile/ui/widgets/loading_button.dart';
import 'package:mpg_mobile/ui/widgets/table.dart';
import 'package:mpg_mobile/viewmodels/cost_estimator/details/labor_tracker_detail_viewmodel.dart';
import 'package:stacked/stacked.dart';

class LaborTrackerDetailView extends StatelessWidget {
  const LaborTrackerDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < Dimensions.m;
    return ViewModelBuilder<LaborTrackerDetailViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) => SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                  padding: const EdgeInsets.all(20),
                ),
                const Text(
                  'Labor tracking',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                )
              ],
            ),
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: isMobile
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: Dimensions.m,
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              title: const Text('Project start date'),
                              subtitle:
                                  Text(dateFormat.format(model.startDate!)),
                            ),
                            ListTile(
                              title: const Text('Project end date'),
                              subtitle: Text(dateFormat.format(model.endDate!)),
                            ),
                          ],
                        ),
                      ),
                      AppTable(
                        columns: model.columns,
                        rows: model.rows,
                      ),
                      AppFormButton(
                        margin: const EdgeInsets.only(top: 20, left: 20),
                        child: model.isBusy
                            ? const LoadingButton()
                            : const Text('Save'),
                        onPressed: model.isUpdated && !model.isBusy
                            ? model.onSaveWeeklyHours
                            : null,
                      ),
                      const SizedBox(height: 20),
                      AppTable(
                        columns: model.balanceColumns,
                        rows: model.balanceRows,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      viewModelBuilder: () => LaborTrackerDetailViewModel(),
    );
  }
}
