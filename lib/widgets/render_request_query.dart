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
        ListView.builder(
          itemCount: queryParams.length,
          itemBuilder: (context, index){
            return(Row(
              children: [
                TextFormField(initialValue: queryParams.keys.elementAt(index),),
                TextFormField(initialValue: queryParams[queryParams.keys.elementAt(index)] as String)
              ],
            ));
        })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return renderQueryOptions();
  }
}
