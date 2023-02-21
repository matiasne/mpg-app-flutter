import 'package:flutter/material.dart';
import 'package:mpg_mobile/viewmodels/cost_estimator/create/proposal/schedule_form_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ScheduleFormView extends StatelessWidget {
  const ScheduleFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ScheduleFormViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) => Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: model.startDateController,
              decoration: const InputDecoration(
                labelText: "Start date",
              ),
              onTap: () async {
                DateTime? date = DateTime(1900);
                FocusScope.of(context).requestFocus(FocusNode());
                date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100));

                model.setBeginDate(date);
              },
            ),
            TextFormField(
              controller: model.endDateController,
              decoration: const InputDecoration(
                labelText: "End date",
              ),
              onTap: () async {
                DateTime? date = DateTime(1900);
                FocusScope.of(context).requestFocus(FocusNode());
                date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100));

                model.setEndDate(date);
              },
            ),
          ],
        ),
      ),
      viewModelBuilder: () => ScheduleFormViewModel(),
    );
  }
}
