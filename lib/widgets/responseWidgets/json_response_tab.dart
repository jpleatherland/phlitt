import 'package:flutter/material.dart';
import 'package:json_view/json_view.dart'; // Import the JsonView package

class JsonResponseTab extends StatefulWidget {
  const JsonResponseTab({
    super.key,
    required this.isFetching,
    required this.responseData,
  });

  final bool isFetching;
  final dynamic responseData;

  @override
  State<JsonResponseTab> createState() => _JsonResponseTabState();
}

class _JsonResponseTabState extends State<JsonResponseTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    print('JsonResponseTab: responseData type = '
            '[33m[1m[4m[7m' +
        widget.responseData.runtimeType.toString() +
        '\u001b[0m');
    print('JsonResponseTab: responseData preview = '
            '[36m' +
        widget.responseData.toString().substring(
            0,
            widget.responseData.toString().length > 200
                ? 200
                : widget.responseData.toString().length) +
        '\u001b[0m');

    if (widget.isFetching) {
      return const Center(child: CircularProgressIndicator());
    }

    dynamic jsonToShow = widget.responseData;
    // Fallback to static JSON if data is not a Map or List
    if (jsonToShow is! Map && jsonToShow is! List) {
      print(
          'JsonResponseTab: responseData is not a Map or List, using fallback');
      jsonToShow = {'example': 'This is a fallback JSON object.'};
    }
    // Optionally, limit size for debugging
    if (jsonToShow is Map && jsonToShow.length > 1000) {
      print('JsonResponseTab: responseData too large, using fallback');
      jsonToShow = {'error': 'JSON too large to display.'};
    }

    return JsonConfig(
      data: JsonConfigData(
        style: const JsonStyleScheme(
          openAtStart: true,
          depth: 1,
        ),
      ),
      child: JsonView(
        controller: _scrollController,
        json: jsonToShow,
      ),
    );
  }
}
