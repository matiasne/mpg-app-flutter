import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/views/business_valuation/detail/valuation_ranking/ranking_inputs_view.dart';
import 'package:mpg_mobile/ui/views/business_valuation/detail/valuation_ranking/ranking_results_view.dart';
import 'package:mpg_mobile/viewmodels/business_valuation/detail/valuation_ranking/valuation_by_ranking_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ValuationByRankingView extends StatelessWidget {
 const ValuationByRankingView({Key? key}) : super(key: key);

 @override
 Widget build(BuildContext context) {
   return ViewModelBuilder<ValuationByRankingViewModel>.reactive(
     builder: (context, model, child) => SingleChildScrollView(
        child: Column(
          children: const [
            RankingInputsView(),
            RankingResultsView(),
          ],
        ),
      ),
     viewModelBuilder: () => ValuationByRankingViewModel(),
   );
 }
}