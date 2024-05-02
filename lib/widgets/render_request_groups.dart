import 'package:flutter/material.dart';
import 'package:qapic/model/collections_model.dart';
import 'package:qapic/widgets/custom_context_menu_controller.dart';
import 'package:qapic/utils/collections_manager.dart';
import 'package:qapic/widgets/rename_dialog.dart' as rd;

class RenderCollectionRequestGroups extends StatefulWidget {
  final Collection collection;
  final Function(Request) selectRequest;

  const RenderCollectionRequestGroups(
      {super.key, required this.collection, required this.selectRequest});

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
        setState(
          () => request!.requestName = value as String,
        );
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

    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: collection.requestGroups.length,
        itemBuilder: (BuildContext context, int index) {
          return ExpansionTile(
              title: _ContextMenuRegion(
                  contextMenuBuilder: (BuildContext context, Offset offset) =>
                      renameMenu(offset, context,
                          collection.requestGroups[index], null, newRequest, newRequestGroup),
                  child:
                      Text(collection.requestGroups[index].requestGroupName)),
              children: collection.requestGroups[index].requests
                  .map((e) => _ContextMenuRegion(
                        contextMenuBuilder:
                            (BuildContext context, Offset offset) {
                          return renameMenu(offset, context,
                              collection.requestGroups[index], e, newRequest, newRequestGroup);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 14.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
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
                                  child: Text(e.requestName),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                  .toList());
        });
  }

  AdaptiveTextSelectionToolbar renameMenu(Offset offset, BuildContext context,
      RequestGroup requestGroup, Request? request, Function newRequest, Function newRequestGroup) {
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
        ContextMenuButtonItem(onPressed: () {
          CustomContextMenuController.removeAny();
          newRequest(requestGroup);
          setState(() {});
        },
        label: 'Add Request')
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
