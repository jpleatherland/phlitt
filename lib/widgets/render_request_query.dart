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
    // TODO change query param model to list of objects and add a second key isEnabled
    // this will allow the user to keep their query param but not use it in the current URL

    Map<String, dynamic> queryParams = requestQuery.queryParams;
    Map<String, dynamic> pathVars = requestQuery.pathVariables;

    return Column(
      children: [
        const Flexible(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text('Query Parameters'),
            )),
        Flexible(
          flex: 3,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: queryParams.length,
              itemBuilder: (context, index) {
                return (Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 4.0),
                        child: TextFormField(
                          initialValue: queryParams.keys.elementAt(index),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 4.0),
                        child: TextFormField(
                            initialValue:
                                queryParams[queryParams.keys.elementAt(index)]
                                    as String),
                      ),
                    )
                  ],
                ));
              }),
        ),
        const SizedBox(
          height: 50,
        ),
        const Flexible(
            flex: 1,
            child: Text('Path Variables')),
        Flexible(
          flex: 3,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: pathVars.length,
            itemBuilder: (context, index) {
              return (Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
                    child: TextFormField(
                      initialValue: pathVars.keys.elementAt(index),
                    ),
                  )),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 4.0),
                      child: TextFormField(
                          initialValue: pathVars[pathVars.keys.elementAt(index)]
                              as String),
                    ),
                  )
                ],
              ));
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return renderQueryOptions();
  }
}
