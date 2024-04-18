import 'package:flutter/material.dart';
import 'package:qapic/model/collections_model.dart';
import 'package:qapic/widgets/render_request_groups.dart' as rrq;
import 'package:qapic/pages/tab_data.dart';

class MainPage extends StatefulWidget {
  final Collection collection;
  final String collectionName;

  const MainPage(
      {super.key, required this.collection, required this.collectionName});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  String selectedCollection = '';

  List<dynamic> openRequests = [];

  @override
  Widget build(BuildContext context) {
    Collection collection = widget.collection;
    List<RequestGroup> requestGroups = collection.requestGroups;
    var tabController = TabController(length: openRequests.length, vsync: this);

    void afterBuild() {
      tabController.dispose();
      tabController = TabController(
          length: openRequests.length,
          vsync: this,
          initialIndex: openRequests.indexOf(openRequests.length));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => afterBuild);
    selectedCollection = widget.collectionName;

    void selectRequest(Map<String, dynamic> request) {
      if (!openRequests.contains(request) && mounted) {
        setState(
          () => openRequests.add(request),
        );
        // openRequests.add(request);
        // tabController.dispose();
      }
      // tabController = TabController(
      //     length: openRequests.length,
      //     vsync: this,
      //     initialIndex: openRequests.indexOf(request));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 1,
          child: Column(children: [
            rrq.RenderCollectionRequestGroups(
              collection: collection,
              selectRequest: selectRequest,
            )
          ]),
        ),
        Expanded(
            flex: 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(2.0),
                  child: TabBar(
                      controller: tabController,
                      tabs: openRequests
                          .map(
                            (e) => Tab(text: e.requestName as String),
                          )
                          .toList()),
                ),
                Expanded( child: Text('Hi')
                  // child: TabBarView(
                  //     controller: tabController,
                  //     children: openRequests
                  //         .map(
                  //           (e) => Container(
                  //               padding: const EdgeInsets.all(5.0),
                  //               child: TabData(request: e as Map<String, dynamic>)),
                  //         )
                  //         .toList()),
                ),
              ],
            )),
      ],
    );
  }
}
