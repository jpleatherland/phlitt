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

    void deleteRequest(RequestGroup requestGroup, String requestName) {
      widget.closeOpenRequest(requestGroup.requests
          .where((element) => element.requestName == requestName)
          .first);
      collectionsManager.deleteRequest(requestGroup, requestName);
      setState(() {});
    }

    void deleteRequestGroup(Collection collection, String requestGroupName) {
      for (Request request in collection.requestGroups
          .where(
            (element) => element.requestGroupName == requestGroupName,
          )
          .first
          .requests) {
        widget.closeOpenRequest(request);
      }
      collectionsManager.deleteRequestGroup(collection, requestGroupName);
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

    return Column(
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
                  child: ExpansionTile(
                      dense: true,
                      initiallyExpanded: true,
                      title: _ContextMenuRegion(
                        contextMenuBuilder:
                            (BuildContext context, Offset offset) => renameMenu(
                          offset,
                          context,
                          collection.requestGroups[index],
                          null,
                          newRequest,
                          newRequestGroup,
                          deleteRequest,
                          deleteRequestGroup,
                        ),
                        child: Text(
                          collection.requestGroups[index].requestGroupName,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      children: [
                        ...collection.requestGroups[index].requests.map(
                          (e) => _ContextMenuRegion(
                            contextMenuBuilder:
                                (BuildContext context, Offset offset) {
                              return renameMenu(
                                  offset,
                                  context,
                                  collection.requestGroups[index],
                                  e,
                                  newRequest,
                                  newRequestGroup,
                                  deleteRequest,
                                  deleteRequestGroup);
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 60,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(e.requestMethod,
                                        style: TextStyle(
                                            color:
                                                methodColor(e.requestMethod))),
                                  ),
                                ),
                                Expanded(
                                  child: TextButton(
                                    style: ButtonStyle(
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      CustomContextMenuController.removeAny();
                                      selectRequest(e);
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Tooltip(
                                        message: e.requestName,
                                        child: Text(
                                          e.requestName,
                                          style: TextStyle(
                                              color: colorContext.colorScheme
                                                  .onSecondaryFixed),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() =>
                                newRequest(collection.requestGroups[index]));
                          },
                        ),
                        const Divider(color: Colors.black),
                      ]),
                );
              }),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle),
          onPressed: () => setState(() => newRequestGroup(widget.collection)),
        ),
      ],
    );
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
      behavior: HitTestBehavior.opaque,
      onSecondaryTapUp: _onSecondaryTapUp,
      onTap: _onTap,
      onLongPress: null,
      onLongPressStart: null,
      child: widget.child,
    );
  }
}
