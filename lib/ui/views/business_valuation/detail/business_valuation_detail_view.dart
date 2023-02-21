import 'package:flutter/material.dart';
import 'package:mpg_mobile/models/loan.dart';
import 'package:mpg_mobile/ui/views/business_valuation/detail/loan/loan_view.dart';
import 'package:mpg_mobile/ui/views/business_valuation/detail/profit_loss/profit_loss_view.dart';
import 'package:mpg_mobile/ui/views/business_valuation/detail/projections/projections_view.dart';
import 'package:mpg_mobile/ui/views/business_valuation/detail/valuation_ranking/valuation_by_ranking_view.dart';
import 'package:mpg_mobile/ui/widgets/form_button.dart';
import 'package:mpg_mobile/viewmodels/business_valuation/detail/business_valuation_detail_viewmodel.dart';
import 'package:stacked/stacked.dart';

class BusinessValuationDetailView extends StatefulWidget {
  final int? businessValuationId;
  const BusinessValuationDetailView({Key? key, this.businessValuationId})
      : super(key: key);

  @override
  State<BusinessValuationDetailView> createState() =>
      _BusinessValuationDetailViewState();
}

class _BusinessValuationDetailViewState
    extends State<BusinessValuationDetailView> with TickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: tabs.length);
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  List<Tab> tabs = const [
    // in speadsheets, this is multiples blank
    Tab(text: "PROJECTIONS"),
    Tab(text: "VALUATION BY RANKING"),
    Tab(text: "PROFIT & LOSS"),
  ];

  openLoanCalculator(Loan? loan) => showDialog(
        context: context,
        builder: (context) => Material(child: LoanView(loan: loan)),
      );

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BusinessValuationDetailViewModel>.reactive(
      onModelReady: (model) =>
          model.fetchBusinessValuation(id: widget.businessValuationId),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: model.goBack,
            ),
            title: Text(model.title),
            actions: [
              if (model.hasLoan)
                AppFormButton(
                    child: const Text('Loan Calculator'),
                    onPressed: model.isBusy ? null : () => openLoanCalculator(model.loan))
            ],
            bottom: TabBar(
                isScrollable: true,
                controller: tabController,
                indicatorColor: Colors.blue,
                unselectedLabelColor: Colors.grey[300],
                labelColor: Colors.white,
                tabs: tabs),
          ),
          body: model.isBusy
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : TabBarView(
                  children: const <Widget>[
                    // in speadsheets, this is multiples blank
                    ProjectionsView(),
                    ValuationByRankingView(),
                    ProfitLossView(),
                  ],
                  controller: tabController,
                ),
        );
      },
      viewModelBuilder: () => BusinessValuationDetailViewModel(),
    );
  }
}
