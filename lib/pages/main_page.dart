import 'package:flutter/material.dart';
import 'package:qapic/widgets/render_request_groups.dart' as rrq;

class MainPage extends StatefulWidget {
  final Iterable collection;
  final String collectionName;

  const MainPage(
      {super.key, required this.collection, required this.collectionName});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with TickerProviderStateMixin {
  String selectedCollection = '';
  Iterable collection = [];
  List requestGroups = [];
  List openRequests = [];

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

    var tabController = TabController(length: openRequests.length, vsync: this);

    void selectRequest(String requestName) {
      if (!openRequests.contains(requestName)) {
        setState(() => openRequests.add(requestName),);
      }
      tabController.index = openRequests.indexOf(requestName);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 1,
          child: Column(children: [
            rrq.RenderRequestGroups(
              requestGroups: requestGroups,
              parentListName: 'requestGroupName',
              selectRequest: selectRequest,
            )
          ]),
        ),
        Expanded(
            flex: 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TabBar(
                    controller: tabController,
                    tabs: openRequests.map(
                        (e) => Tab(text: e),
                      ).toList()),
                SizedBox(height: 50, child: TabBarView(controller: tabController, children: openRequests.map((e) => const Row(children: [Text("data")]),).toList())),
              ],
            )
            ),
      ],
    );
  }
}
