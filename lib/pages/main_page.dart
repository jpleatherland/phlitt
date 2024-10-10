import 'package:flutter/material.dart';
import 'package:flutter_resizable_container/flutter_resizable_container.dart';
import 'package:phlitt/model/collections_model.dart';
import 'package:phlitt/pages/environments_page.dart';
import 'package:phlitt/widgets/render_request_groups.dart';
import 'package:phlitt/pages/active_request.dart';
import 'package:phlitt/widgets/custom_context_menu_controller.dart';

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
    ThemeData colorContext = Theme.of(context);
    ColorScheme colorScheme = colorContext.colorScheme;
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

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return GestureDetector(
        onTap: () => CustomContextMenuController.removeAny(),
        behavior: HitTestBehavior.translucent,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: colorScheme.primary,
              title: Text(collection.collectionName,
                  style: TextStyle(color: colorScheme.onPrimary)),
              actions: [
                IconButton.filled(
                  icon: const Icon(Icons.settings),
                  color: colorContext.colorScheme.onPrimary,
                  iconSize: 37,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EnvironmentsPage(
                        collection: collection,
                        writeback: writeback,
                      ),
                    ),
                  ).then((value) => setState(() {})),
                ),
                Container(
                  decoration:
                      BoxDecoration(color: colorContext.colorScheme.onPrimary),
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
          body: ResizableContainer(
            direction: Axis.horizontal,
            divider: const ResizableDivider(
              padding: 15.0,
              color: Color.fromARGB(25, 0, 0, 0),
            ),
            children: [
              ResizableChild(
                size: const ResizableSize.ratio(0.15),
                minSize: 150,
                maxSize: constraints.maxWidth * 0.2,
                child: InkWell(
                  child: RenderCollectionRequestGroups(
                    collection: collection,
                    selectRequest: selectRequest,
                    closeOpenRequest: closeOpenRequest,
                    renameOpenRequest: renameOpenRequest,
                  ),
                ),
              ),
              ResizableChild(
                  child: Container(
                color: colorContext.colorScheme.surfaceBright,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          top: 2.0, left: 2.0, right: 2.0),
                      color: colorContext.colorScheme.surface,
                      child: TabBar(
                          tabAlignment: TabAlignment.start,
                          dividerColor: colorContext.colorScheme.surfaceDim,
                          isScrollable: true,
                          unselectedLabelColor: Colors.grey,
                          labelPadding: const EdgeInsets.all(0),
                          controller: tabController,
                          tabs: openRequests
                              .map(
                                (e) => Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              color: colorContext
                                                  .colorScheme.surfaceDim))),
                                  child: Tab(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        right: 12.0,
                                        left: 12.0,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(e.requestName),
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () =>
                                                closeOpenRequest(e),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList()),
                    ),
                    Expanded(
                      child: TabBarView(
                          controller: tabController,
                          children: openRequests
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0, bottom: 8.0),
                                  child: ActiveRequest(
                                      request: e,
                                      environment: collection.environments
                                          .where(
                                            (element) =>
                                                element.environmentName ==
                                                environmentController.text,
                                          )
                                          .first),
                                ),
                              )
                              .toList()),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      );
    });
  }
}
