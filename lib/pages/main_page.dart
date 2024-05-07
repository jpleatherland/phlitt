import 'package:flutter/material.dart';
import 'package:qapic/model/collections_model.dart';
import 'package:qapic/pages/environments_page.dart';
import 'package:qapic/widgets/render_request_groups.dart';
import 'package:qapic/pages/active_request.dart';
import 'package:qapic/widgets/custom_context_menu_controller.dart';

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
  TextEditingController environmentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Function writeback = widget.writeback;
    Collection collection = widget.collection;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    environmentController.text == ''
        ? environmentController.text =
            widget.collection.environments.first.environmentName
        : environmentController.text;

    TabController tabController =
        TabController(length: openRequests.length, vsync: this);
    if (openRequests.isNotEmpty) {
      tabController.index = openRequests.length - 1;
    }

    void selectRequest(Request request) {
      if (!openRequests.contains(request)) {
        setState(
          () => openRequests.add(request),
        );
      } else {
        tabController.index = openRequests.indexOf(request);
      }
    }

    void closeOpenRequest(Request request) {
      if (openRequests.contains(request)) {
        setState(
          () => openRequests.remove(request),
        );
      }
    }

    void renameOpenRequest(Request request, String newRequestName) {
      bool wasOpen = false;
      if (openRequests.contains(request)) {
        closeOpenRequest(request);
        wasOpen = true;
      }
      setState(() {
        request.requestName = newRequestName;
        if (wasOpen) selectRequest(request);
      });
    }

    return GestureDetector(
      onTap: () => CustomContextMenuController.removeAny(),
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Text(collection.collectionName,
                style: TextStyle(color: colorScheme.onPrimary)),
            actions: [
              IconButton.filled(
                icon: const Icon(Icons.settings),
                color: Theme.of(context).colorScheme.onPrimary,
                iconSize: 37,
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EnvironmentsPage(
                        collection: collection,
                        writeback: writeback,
                      ),
                    )).then((value) => setState(() {})),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary),
                child: DropdownMenu(
                  controller: environmentController,
                  onSelected: (value) => setState(() {}),
                  dropdownMenuEntries: collection.environments
                      .map((e) => DropdownMenuEntry(
                          value: e.environmentName, label: e.environmentName))
                      .toList(),
                ),
              ),
              IconButton(
                  onPressed: () => writeback(),
                  icon: const Icon(Icons.save),
                  iconSize: 37,
                  color: colorScheme.onPrimary)
            ]),
        body: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 1,
              child: Column(children: [
                RenderCollectionRequestGroups(
                  collection: collection,
                  selectRequest: selectRequest,
                  closeOpenRequest: closeOpenRequest,
                  renameOpenRequest: renameOpenRequest,
                )
              ]),
            ),
            Flexible(
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
                                    child: ActiveRequest(
                                        request: e,
                                        environment: collection.environments
                                            .where(
                                              (element) =>
                                                  element.environmentName ==
                                                  environmentController.text,
                                            )
                                            .first)),
                              )
                              .toList()),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
