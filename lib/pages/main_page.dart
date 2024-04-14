import 'package:flutter/material.dart';
import 'package:dynamic_tabbar/dynamic_tabbar.dart';
import 'package:qapic/widgets/render_request_groups.dart' as rrq;

class MainPage extends StatefulWidget {
  final Iterable collection;
  final String collectionName;

  const MainPage(
      {super.key, required this.collection, required this.collectionName});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String selectedCollection = '';
  Iterable collection = [];
  List requestGroups = [];
  int openRequests = 0;

  // Future<String?> _dialogBuilder(BuildContext context) {
  //   return showDialog<String>(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('Title'),
  //           content: Text('Replace with input field'),
  //           actions: [
  //             TextButton(
  //               style: TextButton.styleFrom(
  //                 textStyle: Theme.of(context).textTheme.labelLarge,
  //               ),
  //               child: const Text('Disable'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //             TextButton(
  //               style: TextButton.styleFrom(
  //                 textStyle: Theme.of(context).textTheme.labelLarge,
  //               ),
  //               child: const Text('Enable'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    selectedCollection = widget.collectionName;
    collection = widget.collection;
    requestGroups = widget.collection.toList()[0]['requestGroups'];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 1,
          child: Column(children: [
            rrq.RenderRequestGroups(
                requestGroups: requestGroups,
                parentListName: 'requestGroupName')
          ]),
        ),
        Expanded(
            flex: 5,
            child: DynamicTabBarWidget(
              onTabControllerUpdated: (controller){},
              dynamicTabs: <TabData>[
              TabData(
                index: 0,
                title: const Tab(
                  child: Text('Request 1'),
                ),
                content: const Center(child: Text('Content for request 1')),
              ),
              TabData(
                index: 1,
                title: const Tab(
                  child: Text('Request 2'),
                ),
                content: const Center(child: Text('Content for request 2')),
              ),
               TabData(
                index: 2,
                title: const Tab(
                  child: Text('Request 3'),
                ),
                content: const Center(child: Text('Content for request 3')),
              ),
            ])),
      ],
    );
  }
}
