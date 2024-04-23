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

  Widget renderQueryOptions() {
    

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
