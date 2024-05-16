import 'package:flutter/material.dart';
import 'package:phlitt/model/collections_model.dart';
import 'package:phlitt/widgets/render_environments.dart';
import 'package:phlitt/widgets/render_environment_parameters.dart';
import 'package:phlitt/widgets/custom_context_menu_controller.dart';

class EnvironmentsPage extends StatefulWidget {
  const EnvironmentsPage({
    super.key,
    required this.collection,
    required this.writeback,
  });
  final Collection collection;
  final Function writeback;

  @override
  State<EnvironmentsPage> createState() => EnvironmentsPageState();
}

class EnvironmentsPageState extends State<EnvironmentsPage> {
  String selectedEnvironment = '';

  void selectEnvironment(String environmentName) {
    setState(() {
      selectedEnvironment = environmentName;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Environment> environments = widget.collection.environments;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => CustomContextMenuController.removeAny(),
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              title: Text('Environments Manager',
                  style: TextStyle(color: colorScheme.onPrimary)),
              actions: [
                IconButton(
                    onPressed: () => widget.writeback(),
                    icon: const Icon(Icons.save),
                    iconSize: 37,
                    color: colorScheme.onPrimary)
              ]),
          body: Row(mainAxisSize: MainAxisSize.min, children: [
            Expanded(
              flex: 1,
              child: RenderEnvironments(
                  collection: widget.collection,
                  selectEnvironment: selectEnvironment),
            ),
            Expanded(
                flex: 5,
                child: selectedEnvironment.isNotEmpty
                    ? RenderEnvironmentParameters(
                        context: context,
                        environment: environments
                            .where(
                                (e) => e.environmentName == selectedEnvironment)
                            .first,
                      )
                    : const Center(child: Text('Select an environment')))
          ])),
    );
  }
}
