import 'package:flutter/material.dart';
import 'package:phlitt/model/collections_model.dart';
import 'package:phlitt/widgets/custom_context_menu_controller.dart';
import 'package:phlitt/utils/collections_manager.dart';
import 'package:phlitt/widgets/rename_dialog.dart' as rd;

class RenderEnvironments extends StatefulWidget {
  final Collection collection;
  final Function(String) selectEnvironment;

  const RenderEnvironments(
      {super.key, required this.collection, required this.selectEnvironment});

  @override
  State<RenderEnvironments> createState() => _RenderEnvironments();
}

class _RenderEnvironments extends State<RenderEnvironments> {
  final collectionsManager = CollectionsManager();

  void environmentUpdated(Environment environment, String newEnvironmentName) {
    setState(() {
      environment.environmentName = newEnvironmentName;
    });
  }

  Widget renderEnvironments() {
    List<Environment> environments = widget.collection.environments;
    Function newEnvironment = collectionsManager.newEnvironment;

    void deleteEnvironment(Collection collection, String environmentName) {
      collectionsManager.deleteEnvironment(collection, environmentName);
      widget.selectEnvironment('');
      setState(() {});
    }

    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: environments.length,
        itemBuilder: (BuildContext context, int index) {
          return _ContextMenuRegion(
            contextMenuBuilder: (BuildContext context, Offset offset) =>
                contextMenu(offset, context, widget.collection,
                    environments[index], newEnvironment, deleteEnvironment),
            child: TextButton(
              onPressed: () => widget.selectEnvironment(
                  widget.collection.environments[index].environmentName),
              child:
                  Text(widget.collection.environments[index].environmentName),
            ),
          );
        });
  }

  AdaptiveTextSelectionToolbar contextMenu(
      Offset offset,
      BuildContext context,
      Collection collection,
      Environment environment,
      Function newEnvironment,
      Function deleteEnvironment) {
    return AdaptiveTextSelectionToolbar.buttonItems(
      anchors: TextSelectionToolbarAnchors(
        primaryAnchor: offset,
      ),
      buttonItems: <ContextMenuButtonItem>[
        ContextMenuButtonItem(
          onPressed: () {
            CustomContextMenuController.removeAny();
            rd.renameEnvironmentDialog(
                context, environment, environmentUpdated);
          },
          label: 'Rename',
        ),
        ContextMenuButtonItem(
          onPressed: () {
            CustomContextMenuController.removeAny();
            newEnvironment(widget.collection);
            setState(() {});
          },
          label: 'Add Environment',
        ),
        ContextMenuButtonItem(
            onPressed: () {
              if (widget.collection.environments.length > 1) {
                CustomContextMenuController.removeAny();
                rd.deleteEnvironmentDialog(context, widget.collection,
                    environment.environmentName, deleteEnvironment);
              } else {
                null;
              }
            },
            label: 'Delete Environment')
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return renderEnvironments();
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
