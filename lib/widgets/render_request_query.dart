import 'package:flutter/material.dart';
import 'package:qapic/model/collections_model.dart';

class RenderRequestQuery extends StatefulWidget {
  final RequestQuery requestQuery;
  final BuildContext context;
  final String requestUrl;
  final Function updateUrl;

  const RenderRequestQuery(
      {super.key,
      required this.requestQuery,
      required this.context,
      required this.requestUrl,
      required this.updateUrl});

  @override
  State<RenderRequestQuery> createState() => _RenderRequestQueryState();
}

class _RenderRequestQueryState extends State<RenderRequestQuery> {
  Widget renderQueryOptions() {
    // TODO change query param model to list of objects and add a second key isEnabled
    // this will allow the user to keep their query param but not use it in the current URL

    Map<String, dynamic> queryParams = widget.requestQuery.queryParams;
    Map<String, dynamic> pathVars = widget.requestQuery.pathVariables;

    List<TextEditingController> queryParamKeyControllers = [];
    List<TextEditingController> queryParamValueControllers = [];
    List<TextEditingController> pathVarsKeyControllers = [];
    List<TextEditingController> pathVarsValueControllers = [];

    void addRequestQuery(String queryType) {
      switch (queryType) {
        case 'queryParam':
          String qpLength = (queryParams.entries.length+1).toString();
          widget.updateUrl(
              '', 'newParam$qpLength', 'newParamValue$qpLength', 'queryParams');
          break;
        case 'pathVars':
          String pvLength = (pathVars.entries.length+1).toString();
          widget.updateUrl(
              '', 'newParam$pvLength', 'newParamValue$pvLength', 'pathVars');
          break;
        default:
      }
    }

    for (int i = 0; i < queryParams.keys.length; i++) {
      queryParamKeyControllers
          .add(TextEditingController(text: queryParams.keys.elementAt(i)));
      queryParamValueControllers.add(TextEditingController(
          text: queryParams[queryParams.keys.elementAt(i)] as String));
    }

    for (int i = 0; i < pathVars.keys.length; i++) {
      pathVarsKeyControllers
          .add(TextEditingController(text: pathVars.keys.elementAt(i)));
      pathVarsValueControllers.add(TextEditingController(
          text: pathVars[pathVars.keys.elementAt(i)] as String));
    }

    return Column(
      children: [
        const Flexible(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text('Query Parameters',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            )),
        Flexible(
          flex: 3,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: queryParams.length,
              itemBuilder: (context, index) {
                return (Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 4.0),
                        child: Focus(
                          canRequestFocus: false,
                          onFocusChange: (hasFocus) => {
                            hasFocus
                                ? null
                                : widget.updateUrl(
                                    queryParams.keys.elementAt(index),
                                    queryParamKeyControllers[index].text,
                                    queryParamValueControllers[index].text,
                                    'queryParams',
                                  )
                          },
                          child: TextFormField(
                              controller: queryParamKeyControllers[index],
                              onFieldSubmitted: (value) => widget.updateUrl(
                                    queryParams.keys.elementAt(index),
                                    queryParamKeyControllers[index].text,
                                    queryParamValueControllers[index].text,
                                    'queryParams',
                                  )),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 4.0),
                          child: Focus(
                            canRequestFocus: false,
                            onFocusChange: (hasFocus) => {
                              hasFocus
                                  ? null
                                  : widget.updateUrl(
                                      queryParams.keys.elementAt(index),
                                      queryParamKeyControllers[index].text,
                                      queryParamValueControllers[index].text,
                                      'queryParams',
                                    )
                            },
                            child: TextFormField(
                                controller: queryParamValueControllers[index],
                                onFieldSubmitted: (value) => widget.updateUrl(
                                      queryParams.keys.elementAt(index),
                                      queryParamKeyControllers[index].text,
                                      queryParamValueControllers[index].text,
                                      'queryParams',
                                    )),
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
            onPressed: () => addRequestQuery('queryParam'),
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        const Flexible(
            flex: 1,
            child: Text('Path Variables',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
        Flexible(
          flex: 3,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: pathVars.length,
            itemBuilder: (context, index) {
              return (Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
                    child: Focus(
                      canRequestFocus: false,
                      onFocusChange: (hasFocus) => {
                        hasFocus
                            ? null
                            : widget.updateUrl(
                                pathVars.keys.elementAt(index),
                                pathVarsKeyControllers[index].text,
                                pathVarsValueControllers[index].text,
                                'pathVars',
                              )
                      },
                      child: TextFormField(
                        controller: pathVarsKeyControllers[index],
                      ),
                    ),
                  )),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 4.0),
                        child: Focus(
                          canRequestFocus: false,
                          onFocusChange: (hasFocus) => {
                            hasFocus
                                ? null
                                : widget.updateUrl(
                                    pathVars.keys.elementAt(index),
                                    pathVarsKeyControllers[index].text,
                                    pathVarsValueControllers[index].text,
                                    'pathVars',
                                  )
                          },
                          child: TextFormField(
                            controller: pathVarsValueControllers[index],
                          ),
                        )),
                  )
                ],
              ));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => addRequestQuery('pathVars'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return renderQueryOptions();
  }
}
