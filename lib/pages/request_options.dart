import 'package:flutter/material.dart';
import 'package:qapic/widgets/request_body.dart';

class RequestOptions extends StatefulWidget {
  final Map<String, dynamic> requestOptions;

  const RequestOptions(
      {super.key, required this.requestOptions});

  @override
  State<RequestOptions> createState() => _RequestOptionsState();
}

class _RequestOptionsState extends State<RequestOptions> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> requestOptions = widget.requestOptions;
    List<String> requestOptionHeadings = requestOptions.keys.toList();

    var tabController = TabController(length: requestOptionHeadings.length, vsync: this);

    updateRequestOptions(String requestHeading, Map<String,dynamic> newOptions){}

    getOptionPage(String requestHeading) {
      switch (requestHeading) {
        case 'body':
          return RequestBody(existingRequestBody: requestOptions[requestHeading], updateRequestOptions: updateRequestOptions,);
        default:
          return const Text('Hi');
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
            flex: 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(2.0),
                  child: TabBar(
                      controller: tabController,
                      tabs: requestOptionHeadings
                          .map(
                            (e) => Tab(text: e.replaceRange(0,1,e[0].toUpperCase())),
                          )
                          .toList()),
                ),
                Expanded(
                  child:
                  TabBarView(
                      controller: tabController,
                      children: requestOptionHeadings.map((e)=>getOptionPage(e)).toList(),
                          ),
                ),
              ],
            )),
      ],
    );
  }
}
