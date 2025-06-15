import 'package:flutter/material.dart';
import 'package:phlitt/utils/requests_manager.dart';
import 'package:phlitt/pages/request_options_page.dart';
import 'package:phlitt/model/collections_model.dart';
// import 'package:phlitt/utils/url_handler.dart';
import 'package:phlitt/widgets/responseWidgets/render_response.dart';
import 'package:flutter_resizable_container/flutter_resizable_container.dart';

class ActiveRequest extends StatefulWidget {
  final Request request;
  final Environment environment;
  const ActiveRequest(
      {super.key, required this.request, required this.environment});

  @override
  ActiveRequestState createState() => ActiveRequestState();
}

class ActiveRequestState extends State<ActiveRequest> {
  final RequestsManager rm = RequestsManager();
  Map<String, dynamic> responseData = {'statusCode': 0, 'body': ''};
  late Request updatedRequest;
  bool isFetching = false;

  final TextEditingController requestMethodController = TextEditingController();
  final TextEditingController urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    updatedRequest = widget.request;
    urlController.text = updatedRequest.requestUrl;
  }

  @override
  void dispose() {
    requestMethodController.dispose();
    urlController.dispose();
    super.dispose();
  }

  Future<void> updateResponse(Map<String, dynamic> response) async {
    if (response['body'] is String) {
      setState(() {
        isFetching = false;
        responseData = {
          'statusCode': response['statusCode'],
          'body': response['body']
        };
      });
    } else {
      try {
        setState(() {
          isFetching = false;
          responseData = {
            'statusCode': response['statusCode'],
            'body': response['body']
          };
        });
      } catch (error) {
        setState(() {
          isFetching = false;
          response['body'] = error.toString();
        });
      }
    }
  }

  Future<void> submitRequest(Request request, Environment? environment) async {
    setState(() => isFetching = true);
    try {
      final response = await rm.submitRequest(updatedRequest, environment);
      updateResponse(response);
    } on FormatException catch (error) {
      updateResponse({'statusCode': 400, 'body': error.message});
    } catch (error) {
      updateResponse({'statusCode': 400, 'body': error.toString()});
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
        break;
    }
    if (send) {
      submitRequest(updatedRequest, widget.environment);
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

    // Save any existing values for our path variables
    for (final pathVars
        in updatedRequest.options.requestQuery.pathVariables.entries) {
      if (updatedPathVariables.keys.contains(pathVars.key)) {
        updatedPathVariables[pathVars.key] = pathVars.value;
      }
    }

    final queryParams = uri.queryParameters;

    setState(() {
      updatedRequest.options.requestQuery.pathVariables = updatedPathVariables;
      updatedRequest.options.requestQuery.queryParams = queryParams;
    });
  }

  void updateUrlQueries(String originalKey, String queryKey, String queryValue,
      String queryType) {
    setState(() {
      final rq = updatedRequest.options.requestQuery;
      String newUrl = updatedRequest.requestUrl;

      if (queryType == 'queryParams') {
        final newParams = Map<String, dynamic>.from(rq.queryParams);
        newParams.remove(originalKey);
        newParams[queryKey] = queryValue;
        updatedRequest.options.requestQuery =
            rq.copyWith(queryParams: newParams);

        // Update the URL string with new query parameters
        final uri = Uri.parse(updatedRequest.requestUrl);
        final updatedUri =
            uri.replace(queryParameters: Map<String, String>.from(newParams));
        newUrl = updatedUri.toString();
      } else if (queryType == 'pathVars') {
        final newVars = Map<String, dynamic>.from(rq.pathVariables);
        newVars.remove(originalKey);
        newVars[queryKey] = queryValue;
        updatedRequest.options.requestQuery =
            rq.copyWith(pathVariables: newVars);

        // Update the URL string with new path variables
        final uri = Uri.parse(updatedRequest.requestUrl);
        List<String> pathSegments = List.from(uri.pathSegments);
        for (int i = 0; i < pathSegments.length; i++) {
          if (pathSegments[i].startsWith(':')) {
            final varName = pathSegments[i].substring(1);
            if (varName == originalKey) {
              pathSegments[i] = ':$queryKey';
            }
          }
        }
        // Add new path variable if not present
        if (!pathSegments.contains(':$queryKey')) {
          pathSegments.add(':$queryKey');
        }
        // Remove any path variables not in newVars
        pathSegments.removeWhere((seg) =>
            seg.startsWith(':') && !newVars.keys.contains(seg.substring(1)));

        final updatedUri = uri.replace(path: pathSegments.join('/'));
        newUrl = updatedUri.toString();
      }

      updatedRequest.requestUrl = newUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          margin: const EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 80, maxWidth: 140),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownMenu<String>(
                    inputDecorationTheme:
                        const InputDecorationTheme(isDense: true),
                    controller: requestMethodController,
                    initialSelection: updatedRequest.requestMethod,
                    dropdownMenuEntries:
                        <String>['GET', 'POST', 'PUT', 'DELETE'].map((value) {
                      return DropdownMenuEntry<String>(
                        value: value,
                        label: value,
                      );
                    }).toList(),
                    onSelected: (value) =>
                        updateRequest('requestMethod', value, false),
                  ),
                ),
              ),
              Expanded(
                flex: 20,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Focus(
                    onFocusChange: (hasFocus) {
                      if (!hasFocus) {
                        updateRequest('requestUrl', urlController.text, false);
                      }
                    },
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 10.0, top: 15.0, right: 10.0, bottom: 17.0),
                          hintText:
                              '{{environmentVariable}}/:pathVar/?queryParam=value&queryParam2=value2'),
                      controller: urlController,
                      onSubmitted: (value) =>
                          updateRequest('requestUrl', value, true),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () =>
                      submitRequest(updatedRequest, widget.environment),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ResizableContainer(
            direction: Axis.horizontal,
            // divider: ResizableDivider(
            //   padding: 15.0,
            //   thickness: 0.25,
            //   color: Theme.of(context).colorScheme.onSurface,
            // ),
            children: [
              ResizableChild(
                size: const ResizableSize.ratio(0.5, min: 275),
                divider: ResizableDivider(
                  padding: 15.0,
                  thickness: 0.25,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                child: SizedBox.expand(
                  child: RenderRequestOptions(
                    requestOptions: updatedRequest.options,
                    requestUrl: updatedRequest.requestUrl,
                    updateUrl: updateUrlQueries,
                  ),
                ),
              ),
              ResizableChild(
                size: const ResizableSize.ratio(0.5, min: 275),
                // minSize: 275,
                child: SizedBox.expand(
                  child: RenderResponse(
                    responseData: responseData,
                    isFetching: isFetching,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
