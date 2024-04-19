import 'package:flutter/material.dart';
import 'package:qapic/widgets/render_request_body.dart';
import 'package:qapic/widgets/render_request_auth.dart';
import 'package:qapic/model/collections_model.dart';

class RenderRequestOptions extends StatelessWidget {
  final RequestOptions requestOptions;

  const RenderRequestOptions(
      {super.key, required this.requestOptions});

   @override
  Widget build(BuildContext context) {
    List<String> requestOptionHeadings = requestOptions.toJson().keys.toList();

    updateRequestOptions(RequestOptions newOptions){
      // String requestHeader = newOptions.keys.first;
      // requestOptions
      var toPrint = requestOptions.requestBody.bodyValue['body'];
      print('new options $newOptions');
      print('requestOptions {$toPrint}');

    }

    Widget getOptionPage(String requestHeading) {
      switch (requestHeading) {
        case 'requestBody':
          return RenderRequestBody(existingRequestOptions: requestOptions, updateRequestOptions: updateRequestOptions,);
        case 'auth':
          return RenderRequestAuth(requestOptions: requestOptions, onUpdated: updateRequestOptions);
        default:
          return Text('$requestHeading to be implemented');
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
            flex: 5,
            child: DefaultTabController(
              length: requestOptionHeadings.length,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2.0),
                    child: TabBar(
                        tabs: requestOptionHeadings
                            .map(
                              (e) => Tab(text: e.replaceRange(0,1,e[0].toUpperCase())),
                            )
                            .toList()),
                  ),
                  Expanded(
                    child:
                    TabBarView(
                        children: requestOptions.toJson().keys.map<Widget>((key) => getOptionPage(key)).toList()
                            ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}