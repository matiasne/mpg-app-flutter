import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mpg_mobile/constants/utils.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/debt_service.dart';
import 'package:mpg_mobile/models/dialog_model.dart';
import 'package:mpg_mobile/services/dialog_service.dart';
import 'package:mpg_mobile/services/ui/cashflow/cashflow_create_service.dart';
import 'package:mpg_mobile/ui/widgets/form_date_field.dart';
import 'package:mpg_mobile/ui/widgets/form_field.dart';
import 'package:mpg_mobile/ui/widgets/form_select_field.dart';
import 'package:stacked/stacked.dart';

class CreateDebtServicesView extends StatelessWidget {
  const CreateDebtServicesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateDebtServicesViewModel>.reactive(
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
              AppFormSelectField(
                controller: model.freqController,
                label: 'Select Frequency',
                items: model.freqOptions,
                onChanged: model.onFreqChanged,
                value: null,
                validator: model.validateRequiredSelect,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              AppFormSelectField(
                label: 'Select Day of the Period',
                formKey: model.periodNumberKey,
                items: model.periodNumberOptions,
                onChanged: model.onPeriodNumberChanged,
                value: model.selectedPeriodNumner,
                validator: model.validateRequiredSelect,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              AppDateField(
                label: 'Select Due date',
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
      viewModelBuilder: () => CreateDebtServicesViewModel(),
    );
  }
}

class CreateDebtServicesViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _cashflowCreateService = locator<CashFlowCreateService>();

  TextEditingController descriptionController = TextEditingController();
  TextEditingController freqController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  final GlobalKey<FormFieldState> periodNumberKey = GlobalKey<FormFieldState>();

  final List<AppSelectOption> freqOptions = [
    AppSelectOption(label: FreqSelectOption.weekly, value: 0),
    AppSelectOption(label: FreqSelectOption.biweekly, value: 1),
    AppSelectOption(label: FreqSelectOption.monthly, value: 2),
  ];

  final List<AppSelectOption> _weeklyOptions = List.generate(
      7, (index) => AppSelectOption(label: "${index + 1}", value: index));

  final List<AppSelectOption> _biweeklyOptions = List.generate(
      14, (index) => AppSelectOption(label: "${index + 1}", value: index));

  final List<AppSelectOption> _monthlyOptions = List.generate(
      28, (index) => AppSelectOption(label: "${index + 1}", value: index));

  List<AppSelectOption> get periodNumberOptions {
    if (_selectedFreq == null) return _weeklyOptions;
    if (_selectedFreq!.label == FreqSelectOption.weekly) return _weeklyOptions;
    if (_selectedFreq!.label == FreqSelectOption.biweekly) {
      return _biweeklyOptions;
    }
    if (_selectedFreq!.label == FreqSelectOption.monthly) {
      return _monthlyOptions;
    }
    return _weeklyOptions;
  }

  AppSelectOption? _selectedFreq;

  AppSelectOption? _selectedPeriodNumber;
  int? get selectedPeriodNumner => _selectedPeriodNumber?.value;

  DateTime? _date;

  final formKey = GlobalKey<FormState>();

  onDateChanged(DateTime? date) {
    if (date == null) return;

    _date = date;
    dateController = TextEditingController(text: dateFormat.format(date));
    notifyListeners();
  }

  onPeriodNumberChanged(int? opt) {
    if (opt == null) return;
    _selectedPeriodNumber = periodNumberOptions[opt];
  }

  onFreqChanged(int? opt) {
    if (opt == null) return;
    _selectedPeriodNumber = null;
    periodNumberKey.currentState?.reset();
    _selectedFreq = freqOptions[opt];
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

    DebtService ds = DebtService(
      description: descriptionController.text,
      freq: _selectedFreq!.label,
      periodNumber: _selectedPeriodNumber!.value!,
      date: _date!,
      amount: double.parse(amountController.text),
    );

    _cashflowCreateService.addTableEntry(
        value: ds, type: TableEntryType.debtService);
    _dialogService.dialogComplete(DialogResponse(confirmed: true));
  }
}

class FreqSelectOption {
  static String weekly = 'weekly';
  static String biweekly = 'bi-weekly';
  static String monthly = 'monthly';
}
