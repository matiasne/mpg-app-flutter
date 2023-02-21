import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mpg_mobile/constants/utils.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/account_payable.dart';
import 'package:mpg_mobile/models/dialog_model.dart';
import 'package:mpg_mobile/services/dialog_service.dart';
import 'package:mpg_mobile/services/ui/cashflow/cashflow_create_service.dart';
import 'package:mpg_mobile/ui/widgets/form_date_field.dart';
import 'package:mpg_mobile/ui/widgets/form_field.dart';
import 'package:stacked/stacked.dart';

class CreateAccountPayableView extends StatelessWidget {
  const CreateAccountPayableView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateAccountPayableViewModel>.reactive(
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
      viewModelBuilder: () => CreateAccountPayableViewModel(),
    );
  }
}

class CreateAccountPayableViewModel extends BaseViewModel {
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

    AccountPayable ap = AccountPayable(
      description: descriptionController.text,
      date: _date!,
      amount: double.parse(amountController.text),
    );

    _cashflowCreateService.addTableEntry(
        value: ap, type: TableEntryType.accountPayable);
    _dialogService.dialogComplete(DialogResponse(confirmed: true));
  }
}

class FreqSelectOption {
  static const String weekly = 'weekly';
  static const String biweekly = 'bi-weekly';
  static const String monthly = 'monthly';
}
