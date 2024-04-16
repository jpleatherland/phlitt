import 'package:flutter/material.dart';

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
                const Expanded(
                  child: Text('hello')
                  // TabBarView
                  //     controller: tabController,
                  //     children: 
                  //         ),
                ),
              ],
            )),
      ],
    );
  }
}
