import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:phlitt/utils/requests_manager.dart';
import 'package:phlitt/pages/request_options_page.dart';
import 'package:phlitt/model/collections_model.dart';
import 'package:phlitt/utils/url_handler.dart';

class ActiveRequest extends StatefulWidget {
  final Request request;
  final Environment environment;
  const ActiveRequest(
      {super.key, required this.request, required this.environment});

  @override
  State<ActiveRequest> createState() => _ActiveRequestState();
}

class _ActiveRequestState extends State<ActiveRequest> {
  RequestsManager rm = RequestsManager();
  Map<String, dynamic> responseData = {'statusCode': 0, 'body': ''};
  late Request updatedRequest;
  bool isFetching = false;
  @override
  void initState() {
    super.initState();
    updatedRequest = widget.request;
  }

  @override
  void dispose() {
    requestMethodController.dispose();
    super.dispose();
  }

  final TextEditingController requestMethodController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Environment? environment = widget.environment;
    TextEditingController urlController =
        TextEditingController(text: updatedRequest.requestUrl);

    void updateResponse(Map<String, dynamic> response) {
      const encoder = JsonEncoder.withIndent('    ');
      String prettyResponse = encoder.convert(response['body']);
      if (mounted) {
        setState(
          () {
            isFetching = false;
            responseData = {
              'statusCode': response['statusCode'],
              'body': prettyResponse
            };
          },
        );
      }
    }

    void updateRequestQueries(String requestUrl) {
      final uri = Uri.parse(requestUrl);
      Map<String, dynamic> updatedPathVariables = {};
      final pathVariables = uri.pathSegments;

      for (final pathVar in pathVariables) {
        if (pathVar.startsWith(':')) {
          updatedPathVariables[pathVar.split(':')[1]] = '';
        }
      }

      //save any existing values for our path variables
      for (final pathVars
          in updatedRequest.options.requestQuery.pathVariables.entries) {
        if (updatedPathVariables.keys.contains(pathVars.key)) {
          updatedPathVariables[pathVars.key] = pathVars.value;
        }
      }

      final queryParams = uri.queryParameters;

      setState(() {
        updatedRequest.options.requestQuery.pathVariables =
            updatedPathVariables;
        updatedRequest.options.requestQuery.queryParams = queryParams;
      });
    }

    void updateUrlQueries(String originalKey, String queryKey,
        String queryValue, String queryType) {
      String parsedUrl =
          replacePlaceholders(updatedRequest.requestUrl, environment);
      Uri currentUrl = Uri.parse(parsedUrl);
      String currentScheme = currentUrl.scheme;
      String currentHost = currentUrl.host;
      int currentPort = currentUrl.port;
      String currentPath = currentUrl.path;
      List<String> splitPath = currentUrl.path.split('/').sublist(1);
      Map<int, String> splitIndexedPath = {};
      splitPath.asMap().forEach((key, value) => splitIndexedPath[key] = value);
      Map<String, String> currentQueryParams = currentUrl.queryParameters;

      switch (queryType) {
        case 'queryParams':
          Map<String, dynamic> newQueryParameters = {};
          updatedRequest.options.requestQuery.queryParams.forEach((key, value) {
            if (key == originalKey) {
              newQueryParameters[queryKey] = queryValue;
            } else {
              newQueryParameters[key] = value;
            }
          });
          if (!newQueryParameters.containsKey(queryKey)) {
            newQueryParameters[queryKey] = queryValue;
          }
          updatedRequest.options.requestQuery.queryParams = newQueryParameters;
          String newUrl = Uri(
                  scheme: currentScheme,
                  host: currentHost,
                  port: currentPort,
                  path: currentPath,
                  queryParameters:
                      updatedRequest.options.requestQuery.queryParams)
              .toString();
          String interpolatedUrl = insertPlaceholder(newUrl, environment);
          updatedRequest.requestUrl = interpolatedUrl;
          break;
        case 'pathVars':
          Map<String, dynamic> newPathVariables = {};
          updatedRequest.options.requestQuery.pathVariables
              .forEach((key, value) {
            if (key == originalKey) {
              newPathVariables[queryKey] = queryValue;
            } else {
              newPathVariables[key] = value;
            }
          });
          if (!newPathVariables.containsKey(queryKey)) {
            newPathVariables[queryKey] = queryValue;
          }
          updatedRequest.options.requestQuery.pathVariables = newPathVariables;
          splitIndexedPath.forEach((key, value) {
            if (value.startsWith(':') && value.substring(1) == originalKey) {
              splitIndexedPath[key] = ':$queryKey';
            }
          });
          List<String> newPathVars = splitIndexedPath.values.toList();
          if (!newPathVars.contains(':$queryKey')) {
            newPathVars.add(':$queryKey');
          }
          newPathVars.removeWhere((element) =>
              element.startsWith(':') &&
              !newPathVariables.keys.contains(element.substring(1)));
          String newUrl = Uri(
                  scheme: currentScheme,
                  host: currentHost,
                  port: currentPort,
                  path: newPathVars.join('/'),
                  queryParameters: currentQueryParams)
              .toString();
          String interpolatedUrl = insertPlaceholder(newUrl, environment);
          updatedRequest.requestUrl = interpolatedUrl;
        default:
      }
      setState(() {});
    }

    void submitRequest(
        Request request, Function updateResponse, Environment? environment) {
      setState(() => isFetching = true);
      try {
        rm.submitRequest(updatedRequest, updateResponse, environment);
      } on FormatException catch (error) {
        updateResponse({'statusCode': 400, 'body': error.message});
      } catch (error) {
        updateResponse({'statusCode': 400, 'body': error});
      }
    }

    void updateRequest(String key, dynamic value, bool send) {
      switch (key) {
        case 'requestMethod':
          updatedRequest.requestMethod = value as String;
          break;
        case 'requestUrl':
          updatedRequest.requestUrl = value as String;
          updateRequestQueries(value);
        default:
      }
      if (send) {
        submitRequest(updatedRequest, updateResponse, environment);
      }
    }

    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownMenu<String>(
                controller: requestMethodController,
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
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Focus(
                canRequestFocus: false,
                onFocusChange: (hasFocus) => {
                  hasFocus
                      ? null
                      : updateRequest('requestUrl', urlController.text, false)
                },
                child: TextField(
                  controller: urlController,
                  onSubmitted: (value) =>
                      updateRequest('requestUrl', value, true),
                ),
              ),
            )),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () =>
                  submitRequest(updatedRequest, updateResponse, environment),
            )
          ],
        ),
      ),
      Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: RenderRequestOptions(
              requestOptions: updatedRequest.options,
              requestUrl: updatedRequest.requestUrl,
              updateUrl: updateUrlQueries,
            )),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Status Code: ${responseData['statusCode']}',
                  textAlign: TextAlign.right,
                ),
                isFetching
                    ? const Center(child: CircularProgressIndicator())
                    : Expanded(
                        child: SingleChildScrollView(
                          child: SelectableText(
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
