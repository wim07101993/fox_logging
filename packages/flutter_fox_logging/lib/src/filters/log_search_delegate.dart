import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/src/log_list_item.dart';
import 'package:flutter_fox_logging/src/models/logs_controller.dart';

class LogSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => close(context, query),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) => const Icon(Icons.search);

  @override
  Widget buildResults(BuildContext context) {
    Navigator.of(context).pop();
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final controller = LogsController.of(context);
    final logs = controller.value.toList(growable: false);
    return ListView.builder(
      itemCount: logs.length,
      itemBuilder: (context, i) => LogListItem(logRecord: logs[i]),
    );
  }

  @override
  String? get searchFieldLabel => 'Search in logs';
}
