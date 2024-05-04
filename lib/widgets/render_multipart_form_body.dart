import 'package:flutter/material.dart';
import 'package:qapic/model/collections_model.dart';

class RenderMultipartFormBody extends StatefulWidget {
  final RequestOptions requestOptions;

  const RenderMultipartFormBody({
    super.key,
    required this.requestOptions,
  });

  @override
  State<RenderMultipartFormBody> createState() => _RenderMultipartFormBody();
}

class _RenderMultipartFormBody extends State<RenderMultipartFormBody> {
  List<TextEditingController> formPartKeyControllers = [];
  List<TextEditingController> formPartValueControllers = [];
  bool isDirty = false;

  Widget renderMultipartFormBody() {
    Map<String, String> formParts = {};

    if (widget.requestOptions.requestBody.bodyValue == '') {
      widget.requestOptions.requestBody.bodyValue = 'newFormPart=newFormPart';
    }

    if (!widget.requestOptions.requestBody.bodyValue.contains('=')){
      widget.requestOptions.requestBody.bodyValue = '${widget.requestOptions.requestBody.bodyValue}=value';
    }

    if(widget.requestOptions.requestBody.bodyValue.contains('&')){
      widget.requestOptions.requestBody.bodyValue.split('&').forEach((element) {
      var splitElement = element.split('=');
      formParts[splitElement[0]] = splitElement[1];
    });
    } else {
      var splitElement = widget.requestOptions.requestBody.bodyValue.split('=');
      formParts[splitElement[0]] = splitElement[1];
    }

    if (formPartKeyControllers.length > formParts.length) {
      int originalControllerLength = formPartKeyControllers.length;
      int itemsRemoved = 0;
      for (int i = 0; i < originalControllerLength; i++) {
        if (!formParts.keys
            .contains(formPartKeyControllers[i - itemsRemoved].text)) {
          formPartKeyControllers.removeAt(i - itemsRemoved);
          formPartValueControllers.removeAt(i - itemsRemoved);
          itemsRemoved++;
        }
      }
    }

    for (int i = 0; i < formParts.length; i++) {
      if (formPartKeyControllers.length <= i) {
        formPartKeyControllers
            .add(TextEditingController(text: formParts.keys.elementAt(i)));
        formPartValueControllers.add(TextEditingController(
            text: formParts[formParts.keys.elementAt(i)] as String));
      }
    }

    void applyBodyChanges() {
      widget.requestOptions.requestBody.bodyValue = '';
      String parsedBodyValue = '';
      for (int i = 0; i < formPartKeyControllers.length; i++) {
        if (i == formPartKeyControllers.length - 1) {
          parsedBodyValue =
              '$parsedBodyValue${formPartKeyControllers[i].text}=${formPartValueControllers[i].text}';
        } else {
          parsedBodyValue =
              '$parsedBodyValue${formPartKeyControllers[i].text}=${formPartValueControllers[i].text}&';
        }
      }
      setState(() {
        widget.requestOptions.requestBody.bodyType = 'x-www-form-urlencoded';
        widget.requestOptions.requestBody.bodyValue = parsedBodyValue;
        isDirty = false;
      });
    }

    void addEnvParam() {
      setState(() => widget.requestOptions.requestBody.bodyValue =
          '${widget.requestOptions.requestBody.bodyValue}&newBodyKey=newBodyValue');
    }

    void deleteFormPart(int index) {
      // Set the param key to the latest value in the text controller
      // envParamKey might not exist in the original collection
      // if it has been changed and the change not applied
      // then remove the key from the original env params map
      Map<String, String> oldBodyValues = {};
      widget.requestOptions.requestBody.bodyValue.split('&').forEach((element) {
        var splitElement = element.split('=');
        oldBodyValues[splitElement[0]] = splitElement[1];
      });

      Map<String, dynamic> newMap = {};
      int count = 0;

      for (var element in oldBodyValues.entries) {
        count++;
        if (count == index) {
          continue;
        } else {
          newMap[element.key] = element.value;
        }
      }

      widget.requestOptions.requestBody.bodyValue = '';
      String parsedBodyValue = '';
      for (int i = 0; i < newMap.length; i++) {
        if (i == newMap.length - 1) {
          parsedBodyValue =
              '$parsedBodyValue${newMap.entries.elementAt(i).key}=${newMap.entries.elementAt(i).value}';
        } else {
          parsedBodyValue =
              '$parsedBodyValue${newMap.entries.elementAt(i).key}=${newMap.entries.elementAt(i).value}&';
        }
      }
      setState(() {
        isDirty = false;
        widget.requestOptions.requestBody.bodyValue = parsedBodyValue;
      });
    }

    return Column(
      children: [
        const Flexible(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text('Form Parts',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            )),
        Flexible(
          flex: 3,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: formParts.length,
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
                            controller: formPartKeyControllers[index],
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
                            controller: formPartValueControllers[index],
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
                            onPressed: () => deleteFormPart(index),
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
                    onPressed: () => applyBodyChanges(),
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
    return renderMultipartFormBody();
  }
}
