import 'package:flutter/material.dart';
import 'package:phlitt/model/collections_model.dart';
import 'package:phlitt/widgets/custom_context_menu_controller.dart';
import 'package:phlitt/utils/collections_manager.dart';
import 'package:phlitt/widgets/rename_dialog.dart' as rd;

class RenderCollectionRequestGroups extends StatefulWidget {
  final Collection collection;
  final Function(Request) selectRequest;
  final Function(Request) closeOpenRequest;
  final Function(Request, String) renameOpenRequest;

  const RenderCollectionRequestGroups(
      {super.key,
      required this.collection,
      required this.selectRequest,
      required this.closeOpenRequest,
      required this.renameOpenRequest});

  @override
  State<RenderCollectionRequestGroups> createState() =>
      _RenderCollectionRequestGroupsState();
}

class _RenderCollectionRequestGroupsState
    extends State<RenderCollectionRequestGroups> {
  final collectionsManager = CollectionsManager();

  void updateRequest(RequestGroup requestGroup, Request? request,
      String valueToUpdate, dynamic value) {
    switch (valueToUpdate) {
      case 'requestName':
        widget.renameOpenRequest(request!, value as String);
        break;
      case 'requestGroupName':
        setState(() => requestGroup.requestGroupName = value as String);
      default:
    }
  }

  Widget renderCollectionRequestGroups(
      Collection collection, Function selectRequest) {
    Function newRequest = collectionsManager.newRequest;
    Function newRequestGroup = collectionsManager.newRequestGroup;

    ThemeData colorContext = Theme.of(context);

    void deleteRequest(RequestGroup requestGroup, String requestId) {
      widget.closeOpenRequest(requestGroup.requests
          .where((element) => element.requestId == requestId)
          .first);
      collectionsManager.deleteRequest(requestGroup, requestId);
      setState(() {});
    }

    void deleteRequestGroup(Collection collection, String requestGroupId) {
      for (Request request in collection.requestGroups
          .where(
            (element) => element.requestGroupId == requestGroupId,
          )
          .first
          .requests) {
        widget.closeOpenRequest(request);
      }
      collectionsManager.deleteRequestGroup(collection, requestGroupId);
      setState(() {});
    }

    Color methodColor(String methodName) {
      switch (methodName) {
        case 'GET':
          return Colors.green;
        case 'POST':
          return Colors.purple;
        case 'DELETE':
          return Colors.redAccent;
        case 'PUT':
          return Colors.amber;
        default:
          return Colors.black;
      }
    }

    return LayoutBuilder(
        builder: (BuildContext lbContext, BoxConstraints constraints) {
      return Padding(
        padding: const EdgeInsets.only(left: 5.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: collection.requestGroups.length,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Theme(
                      data: colorContext.copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ListTileTheme(
                        contentPadding: const EdgeInsets.only(left: 8.0),
                        dense: true,
                        horizontalTitleGap: 0.0,
                        child: ExpansionTile(
                            dense: true,
                            initiallyExpanded: true,
                            title: _ContextMenuRegion(
                              contextMenuBuilder:
                                  (BuildContext cmbContext, Offset offset) =>
                                      renameMenu(
                                offset,
                                cmbContext,
                                collection.requestGroups[index],
                                null,
                                newRequest,
                                newRequestGroup,
                                deleteRequest,
                                deleteRequestGroup,
                              ),
                              child: Text(
                                collection
                                    .requestGroups[index].requestGroupName,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                            children: [
                              ...collection.requestGroups[index].requests.map(
                                (e) => _ContextMenuRegion(
                                  contextMenuBuilder:
                                      (BuildContext rqCmbContext,
                                          Offset offset) {
                                    return renameMenu(
                                        offset,
                                        rqCmbContext,
                                        collection.requestGroups[index],
                                        e,
                                        newRequest,
                                        newRequestGroup,
                                        deleteRequest,
                                        deleteRequestGroup);
                                  },
                                  child: InkWell(
                                    onTap: () {
                                      CustomContextMenuController.removeAny();
                                      selectRequest(e);
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: constraints.maxWidth < 180
                                                ? 20
                                                : 60,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                constraints.maxWidth < 180
                                                    ? e.requestMethod
                                                        .substring(0, 2)
                                                    : e.requestMethod,
                                                style: TextStyle(
                                                  color: methodColor(
                                                      e.requestMethod),
                                                  overflow: TextOverflow.clip,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Tooltip(
                                                  message: e.requestName,
                                                  child: Text(
                                                    e.requestName,
                                                    style: TextStyle(
                                                        color: colorContext
                                                            .colorScheme
                                                            .onSecondaryFixed),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => setState(() => newRequest(
                                    collection.requestGroups[index])),
                                child: const SizedBox(
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Align(
                                          alignment: Alignment.center,
                                          child: Icon(Icons.add)),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                indent: 5.0,
                                color: Color.fromARGB(75, 0, 0, 0),
                                thickness: 1.0,
                              ),
                            ]),
                      ),
                    );
                  }),
            ),
            InkWell(
              onTap: () => setState(() => newRequestGroup(widget.collection)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  AdaptiveTextSelectionToolbar renameMenu(
      Offset offset,
      BuildContext context,
      RequestGroup requestGroup,
      Request? request,
      Function newRequest,
      Function newRequestGroup,
      Function deleteRequest,
      Function deleteRequestGroup) {
    return AdaptiveTextSelectionToolbar.buttonItems(
      anchors: TextSelectionToolbarAnchors(
        primaryAnchor: offset,
      ),
      buttonItems: <ContextMenuButtonItem>[
        ContextMenuButtonItem(
          onPressed: () {
            CustomContextMenuController.removeAny();
            rd.showDialog(context, requestGroup, request, updateRequest);
          },
          label: 'Rename',
        ),
        ContextMenuButtonItem(
          onPressed: () {
            CustomContextMenuController.removeAny();
            newRequestGroup(widget.collection);
            setState(() {});
          },
          label: 'Add Request Group',
        ),
        ContextMenuButtonItem(
          onPressed: () {
            CustomContextMenuController.removeAny();
            newRequest(requestGroup);
            setState(() {});
          },
          label: 'Add Request',
        ),
        ContextMenuButtonItem(
          onPressed: () {
            if (widget.collection.requestGroups.length > 1) {
              CustomContextMenuController.removeAny();
              rd.deleteRequestGroupDialog(
                  context,
                  widget.collection,
                  requestGroup.requestGroupName,
                  requestGroup.requestGroupId,
                  deleteRequestGroup);
            } else {
              null;
            }
          },
          label: 'Delete Request Group',
        ),
        ContextMenuButtonItem(
            onPressed: () {
              CustomContextMenuController.removeAny();
              rd.deleteRequestDialog(context, requestGroup,
                  request!.requestName, request.requestId, deleteRequest);
            },
            label: 'Delete Request'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return renderCollectionRequestGroups(
        widget.collection, widget.selectRequest);
  }
}

typedef ContextMenuBuilder = Widget Function(
    BuildContext context, Offset offset);

class _ContextMenuRegion extends StatefulWidget {
  const _ContextMenuRegion({
    required this.child,
    required this.contextMenuBuilder,
  });

  final ContextMenuBuilder contextMenuBuilder;

  final Widget child;

  @override
  State<_ContextMenuRegion> createState() => _ContextMenuRegionState();
}

class _ContextMenuRegionState extends State<_ContextMenuRegion> {
  final CustomContextMenuController _contextMenuController =
      CustomContextMenuController();

  void _onSecondaryTapUp(TapUpDetails details) {
    _show(details.globalPosition);
  }

  void _onTap() {
    if (!_contextMenuController.isShown) {
      return;
    }
    _hide();
  }

  void _show(Offset position) {
    _contextMenuController.show(
      context: context,
      contextMenuBuilder: (BuildContext context) {
        return widget.contextMenuBuilder(context, position);
      },
    );
  }

  void _hide() {
    _contextMenuController.remove();
  }

  @override
  void dispose() {
    _hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onSecondaryTapUp: _onSecondaryTapUp,
      onTap: _onTap,
      onLongPress: null,
      onLongPressStart: null,
      child: widget.child,
    );
  }
}
