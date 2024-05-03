import 'package:flutter/material.dart';
import 'package:qapic/model/collections_model.dart';
import 'dart:math';

class RenderRequestHeader extends StatefulWidget {
  final RequestOptions requestOptions;
  final BuildContext context;

  const RenderRequestHeader({
    super.key,
    required this.requestOptions,
    required this.context,
  });

  @override
  State<RenderRequestHeader> createState() =>
      _RenderRequestHeader();
}

class _RenderRequestHeader extends State<RenderRequestHeader> {
  List<TextEditingController> headerKeyControllers = [];
  List<TextEditingController> headerValueControllers = [];
  bool isDirty = false;

  Widget renderQueryOptions() {
    Map<String, dynamic> headers = widget.requestOptions.requestHeaders as Map<String, dynamic>;

    if (headerKeyControllers.length > headers.length) {
      int originalControllerLength = headerKeyControllers.length;
      int itemsRemoved = 0;
      for (int i = 0; i < originalControllerLength; i++) {
        if (!headers.keys
            .contains(headerKeyControllers[i - itemsRemoved].text)) {
          headerKeyControllers.removeAt(i - itemsRemoved);
          headerValueControllers.removeAt(i - itemsRemoved);
          itemsRemoved++;
        }
      }
    }

    for (int i = 0; i < headers.keys.length; i++) {
      if (headerKeyControllers.length <= i) {
        headerKeyControllers
            .add(TextEditingController(text: headers.keys.elementAt(i)));
        headerValueControllers.add(TextEditingController(
            text: headers[headers.keys.elementAt(i)] as String));
      }
    }

    void applyHeaderChanges() {
      widget.requestOptions.requestHeaders = {};
      for (int i = 0; i < headers.keys.length; i++) {
        widget.requestOptions
                .requestHeaders![headerKeyControllers[i].text] =
            headerValueControllers[i].text;
      }
      setState(() {
        isDirty = false;
      });
    }

    void addEnvParam() {
      setState(
        () => widget.requestOptions.requestHeaders![
                'newHeader${widget.requestOptions.requestHeaders?.length ?? Random()}'] =
            'newHeaderValue',
      );
    }

    void deleteHeader(String headerKey, int index) {
      // Set the param key to the latest value in the text controller
      // envParamKey might not exist in the original collection
      // if it has been changed and the change not applied
      // then remove the key from the original env params map
      String oldKey =
          widget.requestOptions.requestHeaders!.entries.elementAt(index).key;
      Map<String, String> newMap = {};
      widget.requestOptions.requestHeaders!.forEach((key, value) {
        String newKey = key == oldKey ? headerKey : key;
        newMap[newKey] = value;
      });
      widget.requestOptions.requestHeaders = newMap;
      setState(() {
        widget.requestOptions.requestHeaders!.remove(headerKey);
      });
    }

    return Column(
      children: [
        const Flexible(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text('Request Headers',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
            )),
        Flexible(
          flex: 3,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: headers.length,
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
                            controller: headerKeyControllers[index],
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
                            controller: headerValueControllers[index],
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
                            onPressed: () => deleteHeader(
                                headerKeyControllers[index].text, index),
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
                    onPressed: () => applyHeaderChanges(),
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
