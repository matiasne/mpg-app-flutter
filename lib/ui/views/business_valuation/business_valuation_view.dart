import 'package:flutter/material.dart';
import 'package:mpg_mobile/constants/route_names.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/business_valuation.dart';
import 'package:mpg_mobile/services/navigation_service.dart';
import 'package:mpg_mobile/ui/widgets/title.dart';
import 'package:mpg_mobile/ui/widgets/tool_description_banner.dart';
import 'package:mpg_mobile/viewmodels/business_valuation/business_valuation_viewmodel.dart';
import 'package:stacked/stacked.dart';

class BusinessValuationView extends StatelessWidget {
  const BusinessValuationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BusinessValuationViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              DescriptionBanner(
                title: model.descriptionTitle,
                fullDescription: model.fullDescription,
                preview: model.preview,
              ),
              const Align(
                alignment: Alignment.center,
                child: AppTitle(title: 'Business Valuations'),
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: model.loadValuations(),
                builder:
                    (context, AsyncSnapshot<List<BusinessValuation>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  List<BusinessValuation> valuations = <BusinessValuation>[];
                  if (snapshot.data != null) {
                    valuations = snapshot.data!;
                  }

                  return Column(
                    children: [
                      BusinessValuationsTableView(
                        valuations: valuations,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: model.onCreateValuation,
          label: const Text('Create'),
          icon: const Icon(Icons.add),
        ),
      ),
      viewModelBuilder: () => BusinessValuationViewModel(),
    );
  }
}

class BusinessValuationsTableView extends StatelessWidget {
  const BusinessValuationsTableView({
    Key? key,
    this.valuations = const <BusinessValuation>[],
  }) : super(key: key);
  final List<BusinessValuation> valuations;

  _toValuationDetail({required BusinessValuation valuation}) {
    locator<NavigationService>().navigateTo(
      businessValuationDetailRoute,
      queryParams: {'id': valuation.id.toString()},
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        showCheckboxColumn: false,
        columns: const [
          DataColumn(label: Text('Name')),
        ],
        rows: valuations
            .map((v) => DataRow(
                  onSelectChanged: (bool? selected) {
                    if (selected != null && selected) {
                      _toValuationDetail(valuation: v);
                    }
                  },
                  cells: <DataCell>[
                    DataCell(Text(v.businessName)),
                  ],
                ))
            .toList(),
      ),
    );
  }
}
