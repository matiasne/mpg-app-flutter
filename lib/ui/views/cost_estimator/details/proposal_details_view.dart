import 'package:flutter/material.dart';
import 'package:mpg_mobile/constants/utils.dart';
import 'package:mpg_mobile/models/client.dart';
import 'package:mpg_mobile/models/key_assumption.dart';
import 'package:mpg_mobile/models/objective.dart';
import 'package:mpg_mobile/models/scope.dart';
import 'package:mpg_mobile/ui/widgets/form_button.dart';
import 'package:mpg_mobile/ui/widgets/form_field.dart';
import 'package:mpg_mobile/ui/widgets/loading_button.dart';
import 'package:mpg_mobile/ui/widgets/subtitle.dart';
import 'package:mpg_mobile/viewmodels/cost_estimator/details/proposal_details_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ProposalDetailsView extends StatelessWidget {
  const ProposalDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProposalDetailsViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(),
      onDispose: (model) => model.onDispose(),
      builder: (context, model, child) => SingleChildScrollView(
        child: Column(
          children: [
            const _ProposalHeader(),
            Container(
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Subtitle(title: 'CREDIT TERMS'),
                  const SizedBox(
                    height: 20,
                  ),
                  AppFormField(
                    controller: model.termsController,
                    label: 'Credit Terms',
                    minLines: 5,
                    maxLines: 5,
                    onChanged: model.onTermsChanged,
                  ),
                  AppFormButton(
                    child: model.isBusy
                        ? const LoadingButton()
                        : const Text('Save'),
                    onPressed: model.termsChanged && model.isNotBusy
                        ? model.onSaveCreditTerms
                        : null,
                  )
                ],
              ),
            ),
            const Divider(
              thickness: 3,
            ),
            _ClientInformation(client: model.client),
            const Divider(
              thickness: 3,
            ),
            _Objectives(objectives: model.objectives),
            const Divider(),
            _Scopes(scopes: model.scopes),
            const Divider(),
            _Schedule(startDate: model.startDate, endDate: model.endDate),
            const Divider(),
            _KeyAssumptions(keyAssumptions: model.keyAssumptions),
            const Divider(),
            _Total(suggestedPrice: model.suggestedPrice),
            Align(
              alignment: Alignment.bottomCenter,
              child: model.isDownloading
                  ? const LoadingButton()
                  : ElevatedButton.icon(
                      onPressed: model.onDownload,
                      icon: const Icon(Icons.download),
                      label: const Text('Download'),
                    ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
      viewModelBuilder: () => ProposalDetailsViewModel(),
    );
  }
}

class _ProposalHeader extends StatelessWidget {
  const _ProposalHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Subtitle(title: 'MPG Management LLC'),
            Text('Date: ${dateFormat.format(DateTime.now())}')
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Subtitle(title: 'Eric Andersson'),
            Text('Phone: 2165093200'),
          ],
        ),
      ],
    );
  }
}

class _ClientInformation extends StatelessWidget {
  final Client? client;
  const _ClientInformation({Key? key, required this.client}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('Client Business Name'),
          subtitle: Text(client!.name),
        ),
        const Divider(),
        ListTile(
          title: const Text('Client Address'),
          subtitle: Text(client!.address),
        ),
        const Divider(),
        ListTile(
          title: const Text('City/State:'),
          subtitle: Text(client!.cityState),
        ),
        const Divider(),
        ListTile(
          title: const Text('ZIP Code'),
          subtitle: Text(client!.zipCode),
        ),
        const Divider(),
        ListTile(
          title: const Text('Client Phone Number'),
          subtitle: Text(client!.phoneNumber),
        ),
        const Divider(),
        ListTile(
          title: const Text('Client email address'),
          subtitle: Text(client!.email),
        ),
        const Divider(),
        ListTile(
          title: const Text('Client Contact Person'),
          subtitle: Text(client!.contactName),
        )
      ],
    );
  }
}

class _Objectives extends StatelessWidget {
  final List<Objective>? objectives;
  const _Objectives({Key? key, this.objectives = const []}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Subtitle(title: 'Purpose Statement / Objective'),
        ...objectives!
            .asMap()
            .map((index, objective) => MapEntry(
                index,
                ListTile(
                  leading: Text((index + 1).toString()),
                  title: Text(objective.description),
                )))
            .values
            .toList(),
      ],
    );
  }
}

class _Scopes extends StatelessWidget {
  final List<Scope>? scopes;
  const _Scopes({Key? key, this.scopes = const []}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Subtitle(title: 'Purpose Statement / Objective'),
        ...scopes!
            .asMap()
            .map((index, scope) => MapEntry(
                index,
                ListTile(
                  leading: Text((index + 1).toString()),
                  title: Text(scope.description),
                )))
            .values
            .toList(),
      ],
    );
  }
}

class _Schedule extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  const _Schedule({Key? key, required this.startDate, required this.endDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Subtitle(title: 'Schedule'),
        ListTile(
          title: const Text('Start Date'),
          subtitle: Text(dateFormat.format(startDate!)),
        ),
        ListTile(
          title: const Text('End Date'),
          subtitle: Text(dateFormat.format(endDate!)),
        )
      ],
    );
  }
}

class _KeyAssumptions extends StatelessWidget {
  final List<KeyAssumption>? keyAssumptions;
  const _KeyAssumptions({Key? key, this.keyAssumptions = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Subtitle(title: 'Key Assumptions'),
        ...keyAssumptions!
            .asMap()
            .map((index, scope) => MapEntry(
                index,
                ListTile(
                  leading: Text((index + 1).toString()),
                  title: Text(scope.description),
                )))
            .values
            .toList(),
      ],
    );
  }
}

class _Total extends StatelessWidget {
  final double? suggestedPrice;
  const _Total({Key? key, required this.suggestedPrice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Text(
            'Total: \$${suggestedPrice!.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'PRICE SUBJECT TO REVIEW AFTER 60 DAYS',
            style: TextStyle(color: Colors.grey[500]),
          )
        ],
      ),
    );
  }
}
