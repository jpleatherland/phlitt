import 'package:flutter/material.dart';
import 'package:qapic/widgets/request_body.dart';

class RequestOptions extends StatelessWidget {
  final Map<String, dynamic> requestOptions;

  const RequestOptions(
      {super.key, required this.requestOptions});

   @override
  Widget build(BuildContext context) {
    List<String> requestOptionHeadings = requestOptions.keys.toList();

    updateRequestOptions(Map<String,dynamic> newOptions){
      String requestHeader = newOptions.keys.first;
      requestOptions[requestHeader] = newOptions[requestHeader];
    }

    getOptionPage(String requestHeading) {
      switch (requestHeading) {
        case 'body':
          return RequestBody(existingRequestBody: requestOptions[requestHeading].toString(), updateRequestOptions: updateRequestOptions,);
        default:
          return const Text('Hi');
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
                        children: requestOptionHeadings.map((e)=>getOptionPage(e)).toList(),
                            ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}