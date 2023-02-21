import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/business_valuation.dart';
import 'package:mpg_mobile/models/non_financtial_indicator.dart';
import 'package:mpg_mobile/services/ui/business_valuation/projections.service.dart';
import 'package:mpg_mobile/viewmodels/business_valuation/detail/valuation_ranking/ranking_inputs_viewmodel.dart';
import 'package:stacked/stacked.dart';

class RankingService with ReactiveServiceMixin {
  final _projectionService = locator<ProjectionsService>();

  BusinessValuation? _businessValuation;

  final _nonFinanctialIndicators =
      ReactiveValue<List<NonFinanctialIndicator>>([]);
  List<NonFinanctialIndicator>? get nonFinanctialIndicators =>
      _nonFinanctialIndicators.value;
  updateNonFinanctialIndicators(
      String val, int index, NonFinanctialIndicatorType type) {
    List<NonFinanctialIndicator> nfi = _nonFinanctialIndicators.value;
    if (type == NonFinanctialIndicatorType.ranking) {
      nfi[index].ranking = int.parse(val);
    }
    if (type == NonFinanctialIndicatorType.weight) {
      nfi[index].weight = int.parse(val);
    }
    _nonFinanctialIndicators.value = nfi;
    _reset();
  }

  RankingService() {
    listenToReactiveValues(
        [_nonFinanctialIndicators, _averageAdjustedEstimatedValue]);
  }

  final _averageAdjustedEstimatedValue = ReactiveValue<double>(0);
  double get averageAdjustedEstimatedValue =>
      _averageAdjustedEstimatedValue.value;

  setAverageEstimatedValue() {
    var val = (revenueAdjustedEstimatedValue +
            ebitdaAdjustedEstimatedValue +
            netIncomeAdjustedEstimatedValue) /
        3;
    _averageAdjustedEstimatedValue.value = val;
  }

  double get revenueAdjustedEstimatedValue =>
      _projectionService.revenueEstimatedValue * (_scoreRate / 100);
  double get ebitdaAdjustedEstimatedValue =>
      _projectionService.ebitdaEstimatedValue * (_scoreRate / 100);
  double get netIncomeAdjustedEstimatedValue =>
      _projectionService.netIncomeEstimatedValue * (_scoreRate / 100);

  double get revenueAdjustedMultiplier => _projectionService.revenue == 0
      ? _projectionService.revenue
      : revenueAdjustedEstimatedValue / _projectionService.revenue;
  double get ebitdaAdjustedMultiplier => _projectionService.ebitda == 0
      ? _projectionService.ebitda
      : ebitdaAdjustedEstimatedValue / _projectionService.ebitda;
  double get netIncomeAdjustedMultiplier => _projectionService.netIncome == 0
      ? _projectionService.netIncome
      : netIncomeAdjustedEstimatedValue / _projectionService.netIncome;

  double get revenueAdjustedDiff =>
      revenueAdjustedEstimatedValue - _projectionService.revenueEstimatedValue;
  double get ebitdaAdjustedDiff =>
      ebitdaAdjustedEstimatedValue - _projectionService.ebitdaEstimatedValue;
  double get netIncomeAdjustedDiff =>
      netIncomeAdjustedEstimatedValue -
      _projectionService.netIncomeEstimatedValue;

  int _totalWeight = 0;
  int get totalWeight => _totalWeight;
  int _totalRanking = 0;
  int get totalRanking => _totalRanking;
  double _totalScore = 0;
  double get totalScore => _totalScore;

  double _scoreRate = 0;
  double get scoreRate => _scoreRate;

  initialize({required BusinessValuation businessValuation}) {
    _businessValuation = businessValuation;
    _nonFinanctialIndicators.value =
        _businessValuation!.nonFinanctialIndicators;
    _reset();
  }

  _reset() {
    _calculateTotals();
    setAverageEstimatedValue();
  }

  _calculateTotals() {
    _totalWeight = 0;
    _totalRanking = 0;
    _totalScore = 0;
    for (var fi in nonFinanctialIndicators!) {
      _totalWeight += fi.weight;
      _totalRanking += fi.ranking;
    }

    for (var fi in nonFinanctialIndicators!) {
      double weightPercent = (fi.weight / _totalWeight) * 100;
      _totalScore += (weightPercent / 100) * fi.ranking;
    }
    _scoreRate = (_totalScore / 7) * 100;
  }
}
