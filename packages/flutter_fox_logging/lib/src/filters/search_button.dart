import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/src/filters/log_search_delegate.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showSearch(
        context: context,
        delegate: LogSearchDelegate(),
      ),
      child: const Icon(Icons.search),
    );
  }
}
