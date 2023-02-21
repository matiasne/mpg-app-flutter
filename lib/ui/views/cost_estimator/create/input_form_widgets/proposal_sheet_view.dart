import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/views/cost_estimator/create/input_form_widgets/proposal/items_list/items_list.dart';
import 'package:mpg_mobile/ui/views/cost_estimator/create/input_form_widgets/proposal/labor_tracker_table/labor_tracker_view.dart';
import 'package:mpg_mobile/ui/views/cost_estimator/create/input_form_widgets/proposal/project_info/project_info.dart';
import 'package:mpg_mobile/ui/views/cost_estimator/create/input_form_widgets/proposal/schedule_form/schedule_form_view.dart';
import 'package:mpg_mobile/services/ui/cost_estimator/proposal_sheet_form.service.dart';
import 'package:mpg_mobile/ui/widgets/error_message.dart';
import 'package:mpg_mobile/ui/widgets/loading_button.dart';
import 'package:mpg_mobile/ui/widgets/subtitle.dart';
import 'package:mpg_mobile/viewmodels/cost_estimator/create/proposal_sheet_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ProposalSheetView extends StatelessWidget {
  final Future<void> Function() onSubmit;
  final Function back;
  const ProposalSheetView(
      {Key? key, required this.onSubmit, required this.back})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProposalSheetViewModel>.reactive(
      builder: (context, model, child) => Column(
        children: [
          const Subtitle(title: 'Project information'),
          const ProjectInfoView(),
          const Subtitle(title: 'Purpose Statement / Objective'),
          const ItemsList(type: ListType.objective),
          const Divider(),
          const Subtitle(title: 'Scope of work'),
          const ItemsList(type: ListType.scope),
          const Divider(),
          const Subtitle(title: 'Schedule'),
          const Padding(
            padding: EdgeInsets.all(10),
            child: ScheduleFormView(),
          ),
          const Divider(),
          const Subtitle(title: 'Key assumptions'),
          const ItemsList(type: ListType.keyAssumption),
          const Divider(),
          const Subtitle(title: 'Labor tracking'),
          const LaborTrackerView(),
          if (model.errorMsg.isNotEmpty) ErrorMessage(message: model.errorMsg),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            buttonPadding: const EdgeInsets.all(20),
            children: [
              TextButton(
                onPressed: () => {back()},
                child: const Text('Back'),
              ),
              model.isLoadingCreate
                  ? const LoadingButton()
                  : ElevatedButton(
                      onPressed: () async {
                        bool isValid = model.onSubmit();
                        if (isValid) {
                          model.setLoadingCreate(true);
                          await onSubmit();
                          model.setLoadingCreate(false);
                        }
                      },
                      child: const Text('Submit'),
                    )
            ],
          )
        ],
      ),
      viewModelBuilder: () => ProposalSheetViewModel(),
    );
  }
}
