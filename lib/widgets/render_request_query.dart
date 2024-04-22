import 'package:flutter/material.dart';
import 'package:qapic/model/collections_model.dart';

class RenderRequestQuery extends StatelessWidget {
  final RequestQuery requestQuery;
  final BuildContext context;
  final String requestUrl;
  final Function updateRequestQuery;

  const RenderRequestQuery(
      {super.key,
      required this.requestQuery,
      required this.context,
      required this.requestUrl,
      required this.updateRequestQuery});

  // void updateRequestQuery() {}

  Widget renderQueryOptions() {
    final uri = Uri.parse(requestUrl);
    final pathVariables = uri.pathSegments;
    for (final pathVar in pathVariables) {
      if (pathVar.startsWith(':')) {
        requestQuery.pathVariables[pathVar.split(':')[1]] = '';
      }
    }

    updateRequestQuery(pathVariables)

    requestQuery.queryParams = uri.queryParameters;

    return Column(
      children: [
        ...requestQuery.pathVariables.entries.map(
          (mapEntry) => Text('${mapEntry.key}:${mapEntry.value}'),
        ),
        ...requestQuery.queryParams.entries.map(
          (mapEntry) => Text('${mapEntry.key}:${mapEntry.value}'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return renderQueryOptions();
  }
}
