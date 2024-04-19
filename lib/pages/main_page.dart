import 'package:flutter/material.dart';
import 'package:qapic/model/collections_model.dart';
import 'package:qapic/widgets/render_request_groups.dart';
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
  List<Request> openRequests = [];

  @override
  Widget build(BuildContext context) {
    Collection collection = widget.collection;
    var tabController = TabController(length: openRequests.length, vsync: this);

    void selectRequest(Request request) {
      if (!openRequests.contains(request) && mounted) {
        setState(
          () => openRequests.add(request),
        );
      }
      tabController.dispose();
      tabController = TabController(
          length: openRequests.length,
          vsync: this,
          initialIndex: openRequests.indexOf(request));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 1,
          child: Column(children: [
            RenderCollectionRequestGroups(
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
                            (e) => Tab(text: e.requestName),
                          )
                          .toList()),
                ),
                Expanded(
                  child: TabBarView(
                      controller: tabController,
                      children: openRequests
                          .map(
                            (e) => Container(
                                padding: const EdgeInsets.all(5.0),
                                child: TabData(
                                    request: e)),
                          )
                          .toList()),
                ),
              ],
            )),
      ],
    );
  }
}
