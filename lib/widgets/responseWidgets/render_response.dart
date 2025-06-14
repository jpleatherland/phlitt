import 'dart:convert';

import 'package:flutter/material.dart';
import './json_response_tab.dart';
import './selectable_text_tab.dart';

class RenderResponse extends StatefulWidget {
  RenderResponse({
    super.key,
    required this.responseData,
    required this.isFetching,
  }) {
    print(
        'RenderResponse constructor: responseData = \\${responseData.toString()}');
  }

  final Map<String, dynamic> responseData;
  final bool isFetching;

  @override
  State<RenderResponse> createState() => _RenderResponseState();
}

class _RenderResponseState extends State<RenderResponse>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(
        'RenderResponse build: responseData = \\${widget.responseData.toString()}');
    String responseBody = '';
    if (widget.responseData['body'] is String) {
      responseBody = widget.responseData['body'] as String;
    } else {
      String encodedBody = const JsonEncoder.withIndent('    ')
          .convert(widget.responseData['body']);
      responseBody = encodedBody;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Search components moved to SelectableTextTab
                ],
              ),
              if (widget.isFetching)
                const Center(child: CircularProgressIndicator())
              else ...[
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
                      Text('hi'),
                      // Text('hi2'),
                      // JsonResponseTab(
                      //   isFetching: widget.isFetching,
                      //   responseData: widget.responseData['body'],
                      // ),
                      SelectableTextTab(
                        isFetching: widget.isFetching,
                        responseBody: responseBody,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
