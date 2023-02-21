import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mpg_mobile/constants/utils.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/dialog_model.dart';
import 'package:mpg_mobile/models/one_time_effect.dart';
import 'package:mpg_mobile/services/dialog_service.dart';
import 'package:mpg_mobile/services/ui/cashflow/cashflow_create_service.dart';
import 'package:mpg_mobile/ui/widgets/form_date_field.dart';
import 'package:mpg_mobile/ui/widgets/form_field.dart';
import 'package:stacked/stacked.dart';

class CreateOneTimeEffectView extends StatelessWidget {
  const CreateOneTimeEffectView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateOneTimeEffectViewModel>.reactive(
      builder: (context, model, child) => Form(
        key: model.formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppFormField(
                label: 'Description',
                controller: model.descriptionController,
                validator: model.validateRequired,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              AppDateField(
                label: 'Due date',
                onChanged: model.onDateChanged,
                controller: model.dateController,
                validator: model.validateRequired,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              AppFormField(
                label: 'Amount',
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(doubleRegex),
                ],
                prefix: const Text('\$'),
                controller: model.amountController,
                validator: model.validateRequired,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: model.onSubmit,
                    child: const Text('Create'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      viewModelBuilder: () => CreateOneTimeEffectViewModel(),
    );
  }
}

class CreateOneTimeEffectViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _cashflowCreateService = locator<CashFlowCreateService>();

  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  DateTime? _date;

  final formKey = GlobalKey<FormState>();

  onDateChanged(DateTime? date) {
    if (date == null) return;

    _date = date;
    dateController = TextEditingController(text: dateFormat.format(date));
    notifyListeners();
  }

  onCancel() {
    _dialogService.dialogComplete(DialogResponse(confirmed: false));
  }

  String? validateRequired(String? val) {
    if (val == null || val.isEmpty) return 'Field is required';
    return null;
  }

  String? validateRequiredSelect(int? val) {
    if (val == null) return 'Field is required';
    return null;
  }

  onSubmit() {
    if (!formKey.currentState!.validate()) return;

    OneTimeEffect ote = OneTimeEffect(
      description: descriptionController.text,
      date: _date!,
      amount: double.parse(amountController.text),
    );

    _cashflowCreateService.addTableEntry(
        value: ote, type: TableEntryType.oneTimeEffect);
    _dialogService.dialogComplete(DialogResponse(confirmed: true));
  }
}

class FreqSelectOption {
  static String weekly = 'weekly';
  static String biweekly = 'bi-weekly';
  static String monthly = 'monthly';
}
