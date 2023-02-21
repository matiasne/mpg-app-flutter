import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/views/cashflow/detail/annualized/annualized_view.dart';
import 'package:mpg_mobile/viewmodels/cashflow/detail/cashflow_detail_viewmodel.dart';
import 'package:stacked/stacked.dart';

import 'forecast/forecast_view.dart';

class CashflowDetailView extends StatefulWidget {
  final int? cashflowId;
  const CashflowDetailView({Key? key, this.cashflowId}) : super(key: key);

  @override
  State<CashflowDetailView> createState() =>
      _BusinessValuationDetailViewState();
}

class _BusinessValuationDetailViewState extends State<CashflowDetailView>
    with TickerProviderStateMixin {
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
    Tab(text: "FORECAST"),
    Tab(text: "ANNUALIZED"),
  ];

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CashflowDetailViewModel>.reactive(
      onModelReady: (model) => model.fetchCashflow(id: widget.cashflowId),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: model.goBack,
            ),
            title: Text(model.title),
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
                  children: <Widget>[
                    ForecastView(),
                    const AnnualizedView(),
                  ],
                  controller: tabController,
                ),
        );
      },
      viewModelBuilder: () => CashflowDetailViewModel(),
    );
  }
}
