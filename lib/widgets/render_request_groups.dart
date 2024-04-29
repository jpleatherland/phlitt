import 'package:flutter/material.dart';
import 'package:qapic/model/collections_model.dart';
import 'package:qapic/widgets/custom_context_menu_controller.dart';

class RenderCollectionRequestGroups extends StatelessWidget {
  final Collection collection;
  final Function(Request) selectRequest;

  const RenderCollectionRequestGroups(
      {super.key, required this.collection, required this.selectRequest});

  void _showDialog(BuildContext context, Request request) {
    Navigator.of(context).push(
      DialogRoute<void>(
        context: context,
        builder: (BuildContext context) =>
            Column(
              children: [
                const Text("Request Name:"),
                // TextFormField(initialValue: request.requestName),
              ],
            ),
      ),
    );
  }

  Widget renderCollectionRequestGroups(
      Collection collection, Function selectRequest) {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: collection.requestGroups.length,
        itemBuilder: (BuildContext context, int index) {
          return ExpansionTile(
              title: Text(collection.requestGroups[index].requestGroupName),
              children: collection.requestGroups[index].requests
                  .map((e) => _ContextMenuRegion(
                        contextMenuBuilder:
                            (BuildContext context, Offset offset) {
                          return AdaptiveTextSelectionToolbar.buttonItems(
                            anchors: TextSelectionToolbarAnchors(
                              primaryAnchor: offset,
                            ),
                            buttonItems: <ContextMenuButtonItem>[
                              ContextMenuButtonItem(
                                onPressed: () {
                                  CustomContextMenuController.removeAny();
                                  _showDialog(context, e);
                                },
                                label: 'Rename',
                              ),
                            ],
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 14.0),
                          child: Row(
                            children: [
                              TextButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                    ),
                                  ),
                                ),
                                // dense: true,
                                // trailing: const Icon(Icons.navigate_next),
                                onPressed: () {
                                  CustomContextMenuController.removeAny();
                                  selectRequest(e);},
                                child: Text(e.requestName),
                              ),
                              IconButton(
                                  icon: const Icon(Icons.more_horiz),
                                  onPressed: () {
                                  })
                            ],
                          ),
                        ),
                      ))
                  .toList()
              // renderRequestNames(collection.requestGroups[index].requests),
              );
        });
  }

  @override
  Widget build(BuildContext context) {
    return renderCollectionRequestGroups(collection, selectRequest);
  }
}

typedef ContextMenuBuilder = Widget Function(
    BuildContext context, Offset offset);

class _ContextMenuRegion extends StatefulWidget {
  /// Creates an instance of [_ContextMenuRegion].
  const _ContextMenuRegion({
    required this.child,
    required this.contextMenuBuilder,
  });

  /// Builds the context menu.
  final ContextMenuBuilder contextMenuBuilder;

  /// The child widget that will be listened to for gestures.
  final Widget child;

  @override
  State<_ContextMenuRegion> createState() => _ContextMenuRegionState();
}

class _ContextMenuRegionState extends State<_ContextMenuRegion> {
  final CustomContextMenuController _contextMenuController = CustomContextMenuController();

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