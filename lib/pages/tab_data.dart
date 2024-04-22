import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qapic/utils/requests_manager.dart';
import 'package:qapic/pages/request_options_page.dart';
import 'package:qapic/model/collections_model.dart';

class TabData extends StatefulWidget {
  final Request request;
  const TabData({super.key, required this.request});

  @override
  State<TabData> createState() => _TabDataState();
}

class _TabDataState extends State<TabData> {
  RequestsManager rm = RequestsManager();
  Map<String, dynamic> responseData = {'statusCode': 0, 'body': ''};
  late Request updatedRequest;
  @override
  void initState() {
    super.initState();
    updatedRequest = widget.request;
  }

  @override
  void dispose() {
    super.dispose();
    requestMethodController.dispose();
  }

  final TextEditingController requestMethodController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextEditingController urlController =
        TextEditingController(text: updatedRequest.requestUrl);

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

    void updateRequestQueries(String requestUrl){
      final uri = Uri.parse(requestUrl);
      Map<String, dynamic> updatedQueryParams = {};
      Map<String, dynamic> updatedPathVariables = {}; 
      final pathVariables = uri.pathSegments;
      for (final pathVar in pathVariables) {
        if (pathVar.startsWith(':')) {
          updatedPathVariables[pathVar.split(':')[1]] = '';
        }
      }
            for(final pathVar in updatedRequest.options.requestQuery.pathVariables.keys){
        if(!updatedPathVariables.keys.contains(pathVar)){
          updatedRequest.options.requestQuery.pathVariables.remove(pathVar);
        }
      }
      for (final pathVar in updatedPathVariables.keys) {
        if (updatedRequest.options.requestQuery.pathVariables.keys.contains(pathVar)) {
          updatedPathVariables.remove(pathVar);
        }
      }

      final queryParams = uri.queryParameters;
      //do what was done above for path vars for query params
    }
    updatedRequest.options.requestQuery.pathVariables;

    void updateRequest(String key, dynamic value, bool send) {
      switch (key) {
        case 'requestMethod':
          updatedRequest.requestMethod = value as String;
          break;
        case 'requestUrl':
          updatedRequest.requestUrl = value as String;
          updateRequestQueries(value) as String;
        default:
      }
      if (send) {
        rm.submitRequest(updatedRequest, updateResponse);
      } else {
        print('editingcomplete');
        setState(() {});
      }
    }



    return Column(mainAxisSize: MainAxisSize.min, children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: DropdownMenu<String>(
                controller: requestMethodController,
                label: const Text('Method'),
                initialSelection: updatedRequest.requestMethod,
                dropdownMenuEntries: <String>['GET', 'POST', 'PUT', 'DELETE']
                    .map((String value) {
                  return DropdownMenuEntry<String>(
                    value: value,
                    label: value,
                  );
                }).toList(),
                onSelected: (value) =>
                    updateRequest('requestMethod', value, false)),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Focus(
              canRequestFocus: false,
              onFocusChange: (hasFocus) => {hasFocus ? null : updateRequest('requestUrl', urlController.text, false)},
              child: TextField(
                controller: urlController,
                onSubmitted: (value) =>
                    updateRequest('requestUrl', value, true),
              ),
            ),
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
                child: RenderRequestOptions(
                    requestOptions: updatedRequest.options,
                    requestUrl: updatedRequest.requestUrl)),
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
                      responseData['body'] as String,
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
