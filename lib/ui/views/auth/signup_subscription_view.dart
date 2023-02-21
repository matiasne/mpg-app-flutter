import 'package:flutter/material.dart';
import 'package:mpg_mobile/constants/pricing_plans.dart';
import 'package:mpg_mobile/models/pricing_plan.dart';
import 'package:mpg_mobile/ui/widgets/form_button.dart';
import 'package:mpg_mobile/ui/widgets/subtitle.dart';
import 'package:mpg_mobile/viewmodels/auth/signup_subscription_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SignupSubscriptionView extends StatelessWidget {
  SignupSubscriptionView({Key? key}) : super(key: key);

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignupSubscriptionViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) => Material(
        child: Center(
          child: model.isBusy
              ? const CircularProgressIndicator()
              : Scrollbar(
                  controller: _scrollController,
                  isAlwaysShown: true,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: PricingPlans.plans
                            .map(
                              (plan) => _PlanView(
                                plan: plan,
                                onSelected: () =>
                                    model.goPremium(plan: plan.plan),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
        ),
      ),
      viewModelBuilder: () => SignupSubscriptionViewModel(),
    );
  }
}

class _PlanView extends StatelessWidget {
  const _PlanView({
    Key? key,
    required this.onSelected,
    required this.plan,
  }) : super(key: key);
  final Function() onSelected;
  final PricingPlan plan;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      width: 200,
      height: 350,
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Subtitle(title: plan.title),
          const SizedBox(height: 20),
          Text(
            plan.description,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ...plan.toolsIncluded.map((e) => Text('-' + e)).toList(),
          const Spacer(),
          Subtitle(title: plan.priceDescription),
          const SizedBox(height: 20),
          AppFormButton(
            child: const Text('Select'),
            onPressed: onSelected,
          ),
        ],
      ),
    );
  }
}
