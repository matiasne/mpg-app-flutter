import 'package:flutter/material.dart';
import 'package:mpg_mobile/constants/route_names.dart';
import 'package:mpg_mobile/models/cashflow.dart';
import 'package:mpg_mobile/services/navigation_service.dart';
import 'package:mpg_mobile/ui/widgets/title.dart';
import 'package:mpg_mobile/viewmodels/cashflow/cashflow_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../../locator.dart';
import '../../widgets/tool_description_banner.dart';

class CashFlowView extends StatelessWidget {
  const CashFlowView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CashFlowViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              DescriptionBanner(
                title: model.bannerTitle,
                fullDescription: model.bannerDescription,
                preview: model.bannerPreview,
              ),
              const Align(
                alignment: Alignment.center,
                child: AppTitle(title: 'Cash Flow'),
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: model.loadCashFlows(),
                builder: (context, AsyncSnapshot<List<CashFlow>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  List<CashFlow> results = <CashFlow>[];
                  if (snapshot.data != null) {
                    results = snapshot.data!;
                  }

                  return CashflowTableView(
                    cashflowProjects: results,
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: model.onCreateCashFlow,
          label: const Text('Create'),
          icon: const Icon(Icons.add),
        ),
      ),
      viewModelBuilder: () => CashFlowViewModel(),
    );
  }
}

class CashflowTableView extends StatelessWidget {
  final List<CashFlow>? cashflowProjects;
  const CashflowTableView({Key? key, required this.cashflowProjects})
      : super(key: key);

  _toProjectDetail({required CashFlow cashflow}) {
    locator<NavigationService>().navigateTo(
      cashflowDetailRoute,
      queryParams: {'id': cashflow.id.toString()},
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        showCheckboxColumn: false,
        columns: const <DataColumn>[
          DataColumn(
            label: Text(
              'Name',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ],
        rows: cashflowProjects == null
            ? []
            : cashflowProjects!
                .map((c) => DataRow(
                      onSelectChanged: (bool? selected) {
                        if (selected != null && selected) {
                          _toProjectDetail(cashflow: c);
                        }
                      },
                      cells: <DataCell>[
                        DataCell(Text(c.name)),
                      ],
                    ))
                .toList(),
      ),
    );
  }
}
