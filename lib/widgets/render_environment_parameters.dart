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

  Widget renderEnvironmentParameters() {
    Map<String, dynamic> envParams = widget.environment.environmentParameters;

    if (envParamKeyControllers.length > envParams.length) {
      int originalControllerLength = envParamKeyControllers.length;
      int itemsRemoved = 0;
      for (int i = 0; i < originalControllerLength; i++) {
        if (!envParams.keys
            .contains(envParamKeyControllers[i - itemsRemoved].text)) {
          envParamKeyControllers.removeAt(i - itemsRemoved);
          envParamValueControllers.removeAt(i - itemsRemoved);
          itemsRemoved++;
        }
      }
    }

    for (int i = 0; i < envParams.keys.length; i++) {
      if (envParamKeyControllers.length <= i) {
        envParamKeyControllers
            .add(TextEditingController(text: envParams.keys.elementAt(i)));
        envParamValueControllers.add(TextEditingController(
            text: envParams[envParams.keys.elementAt(i)] as String));
      }
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

    void addEnvParam() {
      setState(
        () => widget.environment.environmentParameters[
                'newEnvParam${widget.environment.environmentParameters.length}'] =
            'newEnvVar',
      );
    }

    void deleteEnvParam(String envParamKey, int index) {
      // Set the param key to the latest value in the text controller
      // envParamKey might not exist in the original collection
      // if it has been changed and the change not applied
      // then remove the key from the original env params map
      String oldKey =
          widget.environment.environmentParameters.entries.elementAt(index).key;
      Map<String, dynamic> newMap = {};
      widget.environment.environmentParameters.forEach((key, value) {
        String newKey = key == oldKey ? envParamKey : key;
        newMap[newKey] = value;
      });
      widget.environment.environmentParameters = newMap;
      setState(() {
        widget.environment.environmentParameters.remove(envParamKey);
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
                    //Keys
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 4.0),
                        child: Focus(
                          onFocusChange: (hasFocus) =>
                              hasFocus ? null : setState(() => isDirty = true),
                          child: TextFormField(
                            controller: envParamKeyControllers[index],
                            onFieldSubmitted: (_) => setState(() {
                              isDirty = true;
                            }),
                          ),
                        ),
                      ),
                    ),
                    //Values
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
                    ),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => deleteEnvParam(
                                envParamKeyControllers[index].text, index),
                          )),
                    )
                  ],
                ));
              }),
        ),
        //Add environment param
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => addEnvParam(),
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
    return renderEnvironmentParameters();
  }
}
