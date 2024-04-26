import 'package:flutter/material.dart';
import 'package:qapic/model/collections_model.dart';
import 'package:qapic/widgets/render_request_groups.dart';
import 'package:qapic/pages/tab_data.dart';

class MainPage extends StatefulWidget {
  final Collection collection;
  final Function writeback;

  const MainPage(
      {super.key, required this.collection, required this.writeback});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  List<Request> openRequests = [];

  @override
  Widget build(BuildContext context) {
    Function writeback = widget.writeback;
    Collection collection = widget.collection;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

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

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(collection.collectionName,
              style: TextStyle(color: colorScheme.onPrimary)),
          actions: [
            IconButton(
                onPressed: () => writeback(),
                icon: const Icon(Icons.save),
                iconSize: 37,
                color: colorScheme.onPrimary)
          ]),
      body: Row(
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
                                  child: TabData(request: e)),
                            )
                            .toList()),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
