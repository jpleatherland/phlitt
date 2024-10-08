import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_view/json_view.dart';
import 'package:phlitt/widgets/highlight_text.dart';

class RenderResponse extends StatefulWidget {
  const RenderResponse({
    super.key,
    required this.responseData,
    required this.isFetching,
  });

  final Map<String, dynamic> responseData;
  final bool isFetching;

  @override
  State<RenderResponse> createState() => _RenderResponseState();
}

class _RenderResponseState extends State<RenderResponse>
    with TickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  Map<int, int> searchResult = {};
  int currentSearchIndex = 0;
  double heightPerLine = 0.0;

  @override
  Widget build(BuildContext context) {
    TabController tabController =
        TabController(length: 2, initialIndex: 1, vsync: this);

    String responseBody = '';

    () {
      if (widget.responseData['body'] is String) {
        setState(
          () => responseBody = widget.responseData['body'] as String,
        );
      } else {
        String encodedBody = const JsonEncoder.withIndent('    ')
            .convert(widget.responseData['body']);
        setState(() => responseBody = encodedBody);
      }
    }();

    void setScrollPoint(int index) {
      if (index > searchResult.length - 1) {
        if (searchResult.containsKey(0)) {
          scrollController.jumpTo(searchResult[0]!.toDouble() * heightPerLine);
          print(searchResult[0]!.toDouble() * heightPerLine);
          print(scrollController.position);
          setState(() => currentSearchIndex = 0);
        }
      } else {
        if (searchResult.containsKey(index)) {
          scrollController
              .jumpTo(searchResult[index]!.toDouble() * heightPerLine);
          print(searchResult[index]!.toDouble() * heightPerLine);
          print(scrollController.position);
          setState(() => currentSearchIndex = index);
        }
      }
    }

    void findMatches(String searchTerm) {
      List<String> splitBody = responseBody.split('\n');
      int outerIndex = 0;
      Map<int, int> matches = {};
      for (int index = 0; index < splitBody.length; index++) {
        if (splitBody[index].contains(searchTerm)) {
          matches[outerIndex] = index;
          outerIndex++;
        }
      }
      setState(() {
        currentSearchIndex = 0;
        heightPerLine =
            scrollController.position.maxScrollExtent / splitBody.length;
        searchResult = matches;
      });
      if (matches.isNotEmpty) {
        setScrollPoint(0);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(hintText: 'search'),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Text(
                    '${currentSearchIndex + 1}/${searchResult.length}',
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setScrollPoint(currentSearchIndex - 1),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () => setScrollPoint(currentSearchIndex + 1),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  findMatches(searchController.text);
                },
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                'Status Code: ${widget.responseData['statusCode']}',
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        widget.isFetching
            ? const Center(child: CircularProgressIndicator())
            : widget.responseData['body'] is String
                ? Text(responseBody)
                : Expanded(
                    child: Column(
                      children: [
                        TabBar(
                          controller: tabController,
                          tabs: const [
                            Tab(
                              height: 25.0,
                              text: 'Json',
                            ),
                            Tab(
                              height: 25.0,
                              text: 'Selectable Text',
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: tabController,
                            children: [
                              JsonConfig(
                                data: JsonConfigData(
                                  style: const JsonStyleScheme(
                                    openAtStart: true,
                                    depth: 1,
                                  ),
                                ),
                                child: JsonView(
                                  controller: scrollController,
                                  json: widget.responseData['body'],
                                ),
                              ),
                              SingleChildScrollView(
                                padding: const EdgeInsets.all(8.0),
                                controller: scrollController,
                                child: SelectableText.rich(
                                  highlightText(
                                    responseBody,
                                    'claim',
                                    const TextStyle(),
                                    const TextStyle(
                                        backgroundColor: Colors.yellowAccent),
                                    true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
      ],
    );
  }
}
