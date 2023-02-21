import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/views/cost_estimator/details/client_information_details_view.dart';
import 'package:mpg_mobile/ui/views/cost_estimator/details/input_form_edit_view.dart';
import 'package:mpg_mobile/ui/views/cost_estimator/details/proposal_details_view.dart';
import 'package:mpg_mobile/ui/views/cost_estimator/details/summary_details_view.dart';
import 'package:mpg_mobile/ui/widgets/form_button.dart';
import 'package:mpg_mobile/viewmodels/cost_estimator/details/project_detail_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'estimate_sheet/estimate_sheet_details_view.dart';
import 'labor_tracker_detail_view.dart';

class ProjectDetailView extends StatefulWidget {
  final int? projectId;
  const ProjectDetailView({Key? key, required this.projectId})
      : super(key: key);

  @override
  _CostEstimatorViewState createState() => _CostEstimatorViewState();
}

class _CostEstimatorViewState extends State<ProjectDetailView>
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
    Tab(text: "INPUTS"),
    Tab(text: "CLIENT INFORMATION"),
    Tab(text: "ESTIMATE SHEET"),
    Tab(text: "SUMMARY"),
    Tab(text: "PROPOSAL SHEET"),
  ];

  displayLaborTracker() {
    showDialog(
        context: context,
        builder: (context) => const Material(child: LaborTrackerDetailView()));
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProjectDetailViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(projectId: widget.projectId),
      onDispose: (model) => model.onDispose(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: model.goBack,
          ),
          actions: [
            AppFormButton(
                child: const Text('Labor tracking'),
                onPressed: model.isBusy ? null : displayLaborTracker)
          ],
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
                children: const <Widget>[
                  InputFormEditView(),
                  ClientInformationDetailsView(),
                  EstimateSheetDetialsView(),
                  SummaryDetailsView(),
                  ProposalDetailsView(),
                ],
                controller: tabController,
              ),
      ),
      viewModelBuilder: () => ProjectDetailViewModel(),
    );
  }
}
