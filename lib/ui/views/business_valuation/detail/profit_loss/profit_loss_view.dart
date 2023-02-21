import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/views/business_valuation/detail/profit_loss/projected/projected_profit_loss_view.dart';
import 'package:mpg_mobile/ui/views/business_valuation/detail/profit_loss/revised/revised_profit_loss_view.dart';
import 'package:mpg_mobile/viewmodels/business_valuation/detail/profit_loss/profit_loss_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ProfitLossView extends StatefulWidget {
  const ProfitLossView({Key? key}) : super(key: key);

  @override
  State<ProfitLossView> createState() => _ProfitLossViewState();
}

class _ProfitLossViewState extends State<ProfitLossView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfitLossViewModel>.reactive(
      builder: (context, model, child) => SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // give the tab bar a height [can change hheight to preferred height]
              Container(
                height: 45,
                constraints: const BoxConstraints(maxWidth: 600),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                ),
                child: TabBar(
                  onTap: model.onTabChanged,
                  controller: _tabController,
                  // give the indicator a decoration (color and border radius)
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      25.0,
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs: const [
                    Tab(
                      text: 'Projected Profit & Loss',
                    ),
                    Tab(
                      text: 'Revised Profit & Loss',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    ProjectedProfitLossView(),
                    RevisedProfitLossView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => ProfitLossViewModel(),
    );
  }
}
