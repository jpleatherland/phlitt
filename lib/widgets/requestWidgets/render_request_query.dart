import 'package:flutter/material.dart';
import 'package:phlitt/model/collections_model.dart';

class RenderRequestQuery extends StatefulWidget {
  final RequestQuery requestQuery;
  final BuildContext context;
  final String requestUrl;
  final void Function(
      String oldKey, String newKey, String newValue, String type) updateUrl;

  RenderRequestQuery({
    super.key,
    required this.requestQuery,
    required this.context,
    required this.requestUrl,
    required this.updateUrl,
  }) {
    print('RenderRequestQuery constructor: requestUrl = \\${requestUrl}');
  }

  @override
  State<RenderRequestQuery> createState() => _RenderRequestQueryState();
}

class _RenderRequestQueryState extends State<RenderRequestQuery> {
  final Map<String, TextEditingController> queryParamKeyControllers = {};
  final Map<String, TextEditingController> queryParamValueControllers = {};
  final Map<String, TextEditingController> pathVarsKeyControllers = {};
  final Map<String, TextEditingController> pathVarsValueControllers = {};

  @override
  void initState() {
    super.initState();
    print('RenderRequestQuery initState: requestUrl = \\${widget.requestUrl}');
    _initControllers();
  }

  @override
  void didUpdateWidget(RenderRequestQuery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.requestQuery != widget.requestQuery) {
      _initControllers();
    }
  }

  void _initControllers() {
    final queryParams = widget.requestQuery.queryParams;
    final pathVars = widget.requestQuery.pathVariables;

    // Clean up controllers that are no longer needed
    queryParamKeyControllers.keys
        .where((k) => !queryParams.containsKey(k))
        .toList()
        .forEach((k) {
      queryParamKeyControllers[k]?.dispose();
      queryParamKeyControllers.remove(k);
    });
    queryParamValueControllers.keys
        .where((k) => !queryParams.containsKey(k))
        .toList()
        .forEach((k) {
      queryParamValueControllers[k]?.dispose();
      queryParamValueControllers.remove(k);
    });
    pathVarsKeyControllers.keys
        .where((k) => !pathVars.containsKey(k))
        .toList()
        .forEach((k) {
      pathVarsKeyControllers[k]?.dispose();
      pathVarsKeyControllers.remove(k);
    });
    pathVarsValueControllers.keys
        .where((k) => !pathVars.containsKey(k))
        .toList()
        .forEach((k) {
      pathVarsValueControllers[k]?.dispose();
      pathVarsValueControllers.remove(k);
    });

    // Add controllers for new keys
    for (final k in queryParams.keys) {
      queryParamKeyControllers.putIfAbsent(
          k, () => TextEditingController(text: k));
      queryParamValueControllers.putIfAbsent(
          k, () => TextEditingController(text: queryParams[k] as String));
    }
    for (final k in pathVars.keys) {
      pathVarsKeyControllers.putIfAbsent(
          k, () => TextEditingController(text: k));
      pathVarsValueControllers.putIfAbsent(
          k, () => TextEditingController(text: pathVars[k] as String));
    }
  }

  @override
  void dispose() {
    for (final controller in [
      ...queryParamKeyControllers.values,
      ...queryParamValueControllers.values,
      ...pathVarsKeyControllers.values,
      ...pathVarsValueControllers.values
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget renderQueryOptions() {
    print('RenderRequestQuery renderQueryOptions: START');
    Map<String, dynamic> queryParams = widget.requestQuery.queryParams;
    Map<String, dynamic> pathVars = widget.requestQuery.pathVariables;

    void addRequestQuery(String queryType) {
      switch (queryType) {
        case 'queryParam':
          String qpLength = (queryParams.entries.length + 1).toString();
          widget.updateUrl(
              '', 'newParam$qpLength', 'newParamValue$qpLength', 'queryParams');
          break;
        case 'pathVars':
          String pvLength = (pathVars.entries.length + 1).toString();
          widget.updateUrl('', 'newPathVar$pvLength',
              'newPathVarValue$pvLength', 'pathVars');
          break;
        default:
      }
    }

    List<Widget> children = [
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: TextButton.icon(
          label: const Text('Query Parameters', style: TextStyle(fontSize: 20)),
          icon: const Icon(Icons.add),
          onPressed: () => addRequestQuery('queryParam'),
        ),
      ),
      ...List.generate(queryParams.length, (index) {
        final key = queryParams.keys.elementAt(index);
        print('RenderRequestQuery queryParams itemBuilder: index = \\${index}');
        return Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
                child: Text('Key: \\${key}'),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
                child: Text('Value: \\${queryParams[key]}'),
              ),
            ),
          ],
        );
      }),
      const SizedBox(height: 40),
      TextButton.icon(
        label: const Text('Path Variables', style: TextStyle(fontSize: 20)),
        icon: const Icon(Icons.add),
        onPressed: () => addRequestQuery('pathVars'),
      ),
      ...List.generate(pathVars.length, (index) {
        final key = pathVars.keys.elementAt(index);
        print('RenderRequestQuery pathVars itemBuilder: index = \\${index}');
        return Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
                child: Text('Key: \\${key}'),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
                child: Text('Value: \\${pathVars[key]}'),
              ),
            ),
          ],
        );
      }),
    ];

    print('RenderRequestQuery renderQueryOptions: END');
    return ListView(
      padding: EdgeInsets.zero,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    print('RenderRequestQuery build: requestUrl = \\${widget.requestUrl}');
    return renderQueryOptions();
  }
}
