import 'package:flutter/material.dart';

class RenderRequestHeader extends StatefulWidget {
  final Map<String, String> headers;
  final void Function(Map<String, String> newHeaders) onHeadersChanged;
  final BuildContext context;

  RenderRequestHeader({
    super.key,
    required this.headers,
    required this.onHeadersChanged,
    required this.context,
  }) {
    print('RenderRequestHeader constructor: headers = \\${headers.toString()}');
  }

  @override
  State<RenderRequestHeader> createState() => _RenderRequestHeader();
}

class _RenderRequestHeader extends State<RenderRequestHeader> {
  late List<TextEditingController> headerKeyControllers;
  late List<TextEditingController> headerValueControllers;
  bool isDirty = false;

  @override
  void initState() {
    super.initState();
    print(
        'RenderRequestHeader initState: headers = \\${widget.headers.toString()}');
    headerKeyControllers = [];
    headerValueControllers = [];
    _initControllers();
  }

  @override
  void didUpdateWidget(RenderRequestHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.headers != oldWidget.headers) {
      _initControllers();
    }
  }

  void _initControllers() {
    headerKeyControllers =
        widget.headers.keys.map((k) => TextEditingController(text: k)).toList();
    headerValueControllers = widget.headers.keys
        .map((k) => TextEditingController(text: widget.headers[k] as String))
        .toList();
  }

  @override
  void dispose() {
    for (final controller in [
      ...headerKeyControllers,
      ...headerValueControllers,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget renderQueryOptions() {
    void applyHeaderChanges() {
      Map<String, String> newHeaders = {};
      for (int i = 0; i < headerKeyControllers.length; i++) {
        newHeaders[headerKeyControllers[i].text] =
            headerValueControllers[i].text;
      }
      widget.onHeadersChanged(newHeaders);
      setState(() {
        isDirty = false;
      });
    }

    void addEnvParam() {
      setState(() {
        final newHeaders = Map<String, String>.from(widget.headers);
        newHeaders['newHeader${widget.headers.length}'] = 'newHeaderValue';
        widget.onHeadersChanged(newHeaders);
        _initControllers();
      });
    }

    void deleteHeader(String headerKey, int index) {
      final newHeaders = Map<String, String>.from(widget.headers);
      newHeaders.remove(headerKey);
      widget.onHeadersChanged(newHeaders);
      setState(() {
        _initControllers();
      });
    }

    return Column(
      children: [
        const Flexible(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text('Request Headers',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            )),
        Flexible(
          flex: 3,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: headerKeyControllers.length,
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
    print(
        'RenderRequestHeader build: headers = \\${widget.headers.toString()}');
    return renderQueryOptions();
  }
}
