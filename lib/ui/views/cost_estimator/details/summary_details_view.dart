import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/widgets/subtitle.dart';
import 'package:mpg_mobile/viewmodels/cost_estimator/details/summary_details_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SummaryDetailsView extends StatelessWidget {
  const SummaryDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SummaryDetailsViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) => Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Subtitle(title: 'Project Costing Sheet'),
              ListTile(
                title: const Text('Client Contact Person'),
                subtitle: Text(model.client!.contactName),
              ),
              const Divider(),
              ListTile(
                title: const Text('Client Business name'),
                subtitle: Text(model.client!.name),
              ),
              const Divider(),
              ListTile(
                title: const Text('Client Phone number'),
                subtitle: Text(model.client!.phoneNumber),
              ),
              const Divider(),
              ListTile(
                title: const Text('Job description'),
                subtitle: Text(model.projectName ?? ''),
              ),
              const Divider(),
              const Subtitle(title: 'Summary'),
              ListTile(
                title: const Text('Total labor hours'),
                subtitle: Text(model.totalHours.toStringAsFixed(2)),
              ),
              const Divider(),
              ListTile(
                title: const Text('Total labor cost'),
                subtitle: Text(model.laborCost.toStringAsFixed(2)),
              ),
              const Divider(),
              ListTile(
                title: const Text('Total fringe cost'),
                subtitle: Text(model.fringeAmount.toStringAsFixed(2)),
              ),
              const Divider(),
              ListTile(
                title: const Text('Total material cost'),
                subtitle: Text(model.materialCost.toStringAsFixed(2)),
              ),
              const Divider(),
              ListTile(
                title: const Text('Total Sub contractor cost'),
                subtitle: Text(model.subContractorCost.toStringAsFixed(2)),
              ),
              const Divider(),
              ListTile(
                title: const Text('Total  Overhead expense cost'),
                subtitle: Text(model.overhead.toStringAsFixed(2)),
              ),
              const Divider(),
              ListTile(
                title: const Text('Total sales comissions'),
                subtitle: Text(model.salesComission.toStringAsFixed(2)),
              ),
              const Divider(),
              ListTile(
                title: const Text('Total profit expense'),
                subtitle: Text(model.profit.toStringAsFixed(2) +
                    '\n' +
                    '% of total customer price: ${model.profitRate.toStringAsFixed(2)} %'),
                isThreeLine: true,
              ),
              const Divider(),
              ListTile(
                title: const Text('Poposal totals'),
                subtitle: Text(model.suggestedPrice.toStringAsFixed(2) +
                    '\n' +
                    '% of total sales: ${model.percentOfSales.toStringAsFixed(2)} %'),
                isThreeLine: true,
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => SummaryDetailsViewModel(),
    );
  }
}
