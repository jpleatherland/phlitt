import 'package:flutter/material.dart';
import 'package:qapic/model/collections_model.dart';

class RenderEnvironmentParameters extends StatefulWidget {
  final Environment environment;
  final BuildContext context;

  const RenderEnvironmentParameters({
    super.key,
    required this.environment,
    required this.context,
  });

  @override
  State<RenderEnvironmentParameters> createState() =>
      _RenderEnvironmentParameters();
}

class _RenderEnvironmentParameters extends State<RenderEnvironmentParameters> {
  List<TextEditingController> envParamKeyControllers = [];
  List<TextEditingController> envParamValueControllers = [];
  bool isDirty = false;

  Widget renderQueryOptions() {
    Map<String, dynamic> envParams = widget.environment.environmentParameters;

    for (int i = 0; i < envParams.keys.length; i++) {
      envParamKeyControllers
          .add(TextEditingController(text: envParams.keys.elementAt(i)));
      envParamValueControllers.add(TextEditingController(
          text: envParams[envParams.keys.elementAt(i)] as String));
    }

    void applyEnvChanges() {
      widget.environment.environmentParameters = {};
      for (int i = 0; i < envParams.keys.length; i++) {
        widget.environment
                .environmentParameters[envParamKeyControllers[i].text] =
            envParamValueControllers[i].text;
      }
      setState(() {
        isDirty = false;
      });
    }

    return Column(
      children: [
        Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text('${widget.environment.environmentName} Parameters',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
            )),
        Flexible(
          flex: 3,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: envParams.length,
              itemBuilder: (context, index) {
                return (Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 4.0),
                        child: TextFormField(
                          controller: envParamKeyControllers[index],
                          onChanged: (_) => setState(() {
                            isDirty = true;
                          }),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 4.0),
                          child: TextFormField(
                            controller: envParamValueControllers[index],
                            onChanged: (_) => setState(() {
                              isDirty = true;
                            }),
                          )),
                    )
                  ],
                ));
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => print('addEnvParam'),
          ),
        ),
        Center(
            child: isDirty
                ? TextButton(
                    onPressed: () => applyEnvChanges(),
                    child: const Text('Apply'))
                : const TextButton(
                    onPressed: null,
                    child: Text('Apply'),
                  ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return renderQueryOptions();
  }
}
