import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qapic/utils/requests_manager.dart';
import 'package:qapic/pages/request_options.dart';

class TabData extends StatefulWidget {
  final Map<String, dynamic> request;

  const TabData({super.key, required this.request});

  @override
  State<TabData> createState() => _TabDataState();
}

class _TabDataState extends State<TabData> {
  Map<String, dynamic> updatedRequest = {};
  RequestsManager rm = RequestsManager();
  Map<String, dynamic> responseData = {'statusCode': 0, 'body': ''};

  @override
  void initState() {
    super.initState();
    updatedRequest = widget.request;
  }

  @override
  void dispose(){
    super.dispose();
    requestMethodController.dispose();
  }

  final TextEditingController requestMethodController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    TextEditingController urlController =
        TextEditingController(text: widget.request['requestUrl']);



    void updateResponse(Map<String, dynamic> response) {
      const encoder = JsonEncoder.withIndent("    ");
      String prettyResponse = encoder.convert(response['body']);
      if (mounted) {
        setState(
          () => responseData = {
            'statusCode': response['statusCode'],
            'body': prettyResponse
          },
        );
      }
    }

    void updateRequest(key, value, send) {
      updatedRequest[key] = value;
      if (send) {
        rm.submitRequest(updatedRequest, updateResponse);
      }
    }

    return Column(mainAxisSize: MainAxisSize.min, children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: DropdownMenu<String>(
                controller:requestMethodController,
                label: const Text('Method'),
                // initialSelection: updatedRequest['requestMethod'],
                dropdownMenuEntries: <String>['GET', 'POST', 'PUT', 'DELETE']
                    .map((String value) {
                  return DropdownMenuEntry<String>(
                    value: value,
                    label: value,
                  );
                }).toList(),
                // onSelected: (value) =>
                //     updateRequest('requestMethod', value, false)
                    ),
          ),
          Expanded(
              child: TextField(
            controller: urlController,
            onSubmitted: (value) => updateRequest('requestUrl', value, true),
            onChanged: (value) => updateRequest('requestUrl', value, false),
          )),
          IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => rm.submitRequest(updatedRequest, updateResponse))
        ],
      ),
      Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child:
                    RequestOptions(requestOptions: updatedRequest['options'])),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Status Code: ${responseData['statusCode']}',
                  textAlign: TextAlign.right,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      responseData['body'],
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            )),
          ],
        ),
      )
    ]);
  }
}
