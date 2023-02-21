import 'package:flutter/material.dart';
import 'package:mpg_mobile/constants/utils.dart';
import 'package:mpg_mobile/models/account_payable.dart';
import 'package:mpg_mobile/models/account_receivable.dart';
import 'package:mpg_mobile/models/business_expense.dart';
import 'package:mpg_mobile/models/cashflow.dart';
import 'package:mpg_mobile/models/debt_service.dart';
import 'package:mpg_mobile/models/one_time_effect.dart';
import 'package:mpg_mobile/models/recurring_income.dart';

class CashFlowCreateService {
  TextEditingController nameController = TextEditingController();
  TextEditingController checkingAccountController = TextEditingController();
  TextEditingController payrollAccountController = TextEditingController();
  TextEditingController savingsAccountController = TextEditingController();
  TextEditingController startDateController = TextEditingController();

  List<RecurringIncome> recurringIncomes = [];
  List<AccountReceivable> accountReceivables = [];
  List<BusinessExpense> businessExpenses = [];
  List<OneTimeEffect> oneTimeEffects = [];
  List<DebtService> debtServices = [];
  List<AccountPayable> accountPayables = [];

  TextEditingController savingsController = TextEditingController();
  TextEditingController locsController = TextEditingController();
  TextEditingController outstandingDrawsController = TextEditingController();
  TextEditingController locsBalanceController = TextEditingController();
  TextEditingController otherSavingsController = TextEditingController();

  addTableEntry({required dynamic value, required TableEntryType type}) {
    switch (type) {
      case TableEntryType.recurringIncome:
        {
          RecurringIncome ri = value as RecurringIncome;
          recurringIncomes.add(ri);
          break;
        }
      case TableEntryType.accountReceivable:
        {
          AccountReceivable ri = value as AccountReceivable;
          accountReceivables.add(ri);
          break;
        }
      case TableEntryType.businessExpense:
        {
          BusinessExpense be = value as BusinessExpense;
          businessExpenses.add(be);
          break;
        }
      case TableEntryType.oneTimeEffect:
        {
          OneTimeEffect ote = value as OneTimeEffect;
          oneTimeEffects.add(ote);
          break;
        }
      case TableEntryType.debtService:
        {
          DebtService ds = value as DebtService;
          debtServices.add(ds);
          break;
        }
      case TableEntryType.accountPayable:
        {
          AccountPayable ap = value as AccountPayable;
          accountPayables.add(ap);
          break;
        }
    }
  }

  CashFlow buildCashFlow({required int userId}) {
    double totalLocs = double.tryParse(locsController.text) ?? 0;
    double outstandingDraws =
        double.tryParse(outstandingDrawsController.text) ?? 0;
    double checkingAccount =
        double.tryParse(checkingAccountController.text) ?? 0;
    double payrollAccount = double.tryParse(payrollAccountController.text) ?? 0;
    double savingsAccount = double.tryParse(savingsAccountController.text) ?? 0;
    DateTime startDate = dateFormat.parse(startDateController.text);
    double borrowingSavings = double.tryParse(savingsController.text) ?? 0;
    double otherSavings = double.tryParse(otherSavingsController.text) ?? 0;
    double locsBalance = totalLocs - outstandingDraws;
    return CashFlow(
      userId: userId,
      name: nameController.text,
      checkingAccount: checkingAccount,
      payrollAccount: payrollAccount,
      savingsAccount: savingsAccount,
      startDate: startDate,
      recurringIncomes: recurringIncomes,
      accountReceivables: accountReceivables,
      businessExpenses: businessExpenses,
      oneTimeEffects: oneTimeEffects,
      debtServices: debtServices,
      accountPayables: accountPayables,
      borrowingSavings: borrowingSavings,
      totalLocs: totalLocs,
      outstandingDraws: outstandingDraws,
      locsBalance: locsBalance,
      otherSavings: otherSavings,
    );
  }

  dispose() {
    nameController = TextEditingController();
    checkingAccountController = TextEditingController();
    payrollAccountController = TextEditingController();
    savingsAccountController = TextEditingController();
    startDateController = TextEditingController();
    recurringIncomes = [];
    accountReceivables = [];
    businessExpenses = [];
    oneTimeEffects = [];
    debtServices = [];
    accountPayables = [];
    savingsController = TextEditingController();
    locsController = TextEditingController();
    outstandingDrawsController = TextEditingController();
    locsBalanceController = TextEditingController();
    otherSavingsController = TextEditingController();
  }
}

enum TableEntryType {
  recurringIncome,
  accountReceivable,
  businessExpense,
  oneTimeEffect,
  debtService,
  accountPayable
}
