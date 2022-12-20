import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/src/filter/log_search_delegate.dart';
import 'package:flutter_fox_logging/src/logs_controller.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({
    super.key,
    required this.logs,
  });

  final LogsController logs;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showSearch(
        context: context,
        delegate: LogSearchDelegate(logs: logs),
      ),
      child: const Icon(Icons.search),
    );
  }
}
