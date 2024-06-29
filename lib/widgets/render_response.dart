import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_view/json_view.dart';

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
  @override
  Widget build(BuildContext context) {
    TabController tabController =
        TabController(length: 2, initialIndex: 1, vsync: this);
    TextEditingController searchController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex: 6,
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
                child: IconButton(
                    onPressed: () {}, icon: const Icon(Icons.search))),
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
                ? Text(widget.responseData['body'] as String)
                : Expanded(
                    child: Column(
                      children: [
                        TabBar(
                          controller: tabController,
                          tabs: const [
                            Tab(
                              text: 'Json',
                            ),
                            Tab(
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
                                  json: widget.responseData['body'],
                                ),
                              ),
                              SingleChildScrollView(
                                child: SelectableText(
                                  const JsonEncoder.withIndent('    ')
                                      .convert(widget.responseData['body']),
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
