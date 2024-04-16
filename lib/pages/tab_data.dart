import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qapic/utils/requests_manager.dart';

class TabData extends StatefulWidget {
  final Map<String, dynamic> request;

  const TabData({super.key, required this.request});

  @override
  State<TabData> createState() => _TabDataState();
}

class _TabDataState extends State<TabData> {
  Map<String, dynamic> updatedRequest = {};
  RequestsManager rm = RequestsManager();
  String responseData = "";

  @override
  void initState() {
    super.initState();
    updatedRequest = widget.request;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController urlController =
        TextEditingController(text: widget.request['requestUrl']);

    void updateResponse(Map<String, dynamic> response) {
      const encoder = JsonEncoder.withIndent("    ");
      String prettyResponse = encoder.convert(response);
      setState(
        () => responseData = prettyResponse,
      );
    }

    void updateRequest(key, value) {
      updatedRequest[key] = value;
      rm.getRequest(updatedRequest, updateResponse);
    }

    return Column(mainAxisSize: MainAxisSize.min, children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: TextField(
                  controller: urlController,
                  onSubmitted: (value) => updateRequest('requestUrl', value))),
          IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => rm.getRequest(updatedRequest, updateResponse))
        ],
      ),
      Expanded(
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(child: Text('options here')),
            Expanded(
                child: Text(
                  responseData.toString(),
                  textAlign: TextAlign.left,
                )),
          ],
        ),
      )
    ]);
  }
}
