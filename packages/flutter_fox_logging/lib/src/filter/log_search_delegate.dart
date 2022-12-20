import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/flutter_fox_logging.dart';

class LogSearchDelegate extends SearchDelegate {
  LogSearchDelegate({
    required this.logs,
  });

  final LogsController logs;

  Iterable<LogRecord> get queriedLogs => logs.value
      .where((logRecord) => query.isEmpty || logRecord.message.contains(query));

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
    return ValueListenableBuilder<Iterable<LogRecord>>(
      valueListenable: logs,
      builder: (context, iterable, _) {
        final logs = queriedLogs.toList(growable: false);
        return ListView.builder(
          itemCount: logs.length,
          itemBuilder: (context, i) => LogListItem(logRecord: logs[i]),
        );
      },
    );
  }

  @override
  String? get searchFieldLabel => 'Search in logs';
}
