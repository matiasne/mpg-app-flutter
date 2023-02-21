import 'package:flutter/material.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/services/ui/cost_estimator/proposal_sheet_form.service.dart';

class ItemsList extends StatefulWidget {
  const ItemsList({Key? key, required this.type}) : super(key: key);
  final String type;

  @override
  _ItemsListState createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  final _proposalSheetFormService = locator<ProposalSheetFormService>();

  final List<String> _items = [];
  final _descriptionController = TextEditingController();

  Future<bool?> _showNewEntryDialog() async {
    return await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Add ${widget.type}'),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  keyboardType: TextInputType.text,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(i, element) {
    return Column(
      children: [
        Row(
          children: [
            Text((i + 1).toString()),
            const Spacer(),
            Text(element),
            const Spacer(),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.redAccent,
              ),
              onPressed: () => _deleteEntry(i),
            )
          ],
        ),
        const Divider(),
      ],
    );
  }

  _deleteEntry(i) {
    _proposalSheetFormService.removeListItem(i, widget.type);
    setState(() {
      _items.removeAt(i);
    });
  }

  _addNewEntry() async {
    bool? result = await _showNewEntryDialog();
    if (result != null && result) {
      _proposalSheetFormService.addListItem(
          _descriptionController.text, widget.type);
      setState(() {
        _items.add(_descriptionController.text);
      });

      _descriptionController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    if (_proposalSheetFormService.isEdit) {
      switch (widget.type) {
        case ListType.objective:
          _items.addAll(
              _proposalSheetFormService.objectives.map((e) => e.description));
          break;
        case ListType.scope:
          _items.addAll(
              _proposalSheetFormService.scopes.map((e) => e.description));
          break;
        case ListType.keyAssumption:
          _items.addAll(_proposalSheetFormService.keyAssumptions
              .map((e) => e.description));
          break;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 35.0,
            ),
            child: ListView(
              shrinkWrap: true,
              children: _items
                  .asMap()
                  .map((i, e) {
                    return MapEntry(
                      i,
                      _buildListItem(i, e),
                    );
                  })
                  .values
                  .toList(),
            )),
        ButtonBar(
          children: [
            ElevatedButton.icon(
                onPressed: _addNewEntry,
                icon: const Icon(Icons.add),
                label: const Text('NEW ENTRY')),
          ],
        )
      ],
    );
  }
}
