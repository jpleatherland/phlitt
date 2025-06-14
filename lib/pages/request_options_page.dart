import 'package:flutter/material.dart';
import 'package:phlitt/widgets/requestWidgets/render_request_body.dart';
import 'package:phlitt/widgets/requestWidgets/render_request_auth.dart';
import 'package:phlitt/widgets/requestWidgets/render_request_query.dart';
import 'package:phlitt/widgets/requestWidgets/render_request_headers.dart';
import 'package:phlitt/model/collections_model.dart';

class RenderRequestOptions extends StatefulWidget {
  final RequestOptions requestOptions;
  final String requestUrl;
  final void Function(String, String, String, String) updateUrl;

  RenderRequestOptions(
      {super.key,
      required this.requestOptions,
      required this.requestUrl,
      required this.updateUrl}) {
    print('RenderRequestOptions constructor: requestUrl = \\$requestUrl');
  }

  @override
  State<RenderRequestOptions> createState() => _RenderRequestOptionsState();
}

class _RenderRequestOptionsState extends State<RenderRequestOptions> {
  @override
  Widget build(BuildContext context) {
    print('RenderRequestOptions build: requestUrl = \\${widget.requestUrl}');
    final optionKeys = widget.requestOptions.toJson().keys.toList();

    List<String> requestOptionHeadings = [
      'Query Params',
      'Body',
      'Headers',
      'Auth'
    ];

    updateRequestOptions(List<String> newOptions) {
      List<String> splitNewOptions = [];
      for (var option in newOptions) {
        if (option.startsWith(':')) {
          splitNewOptions.add(option.split(':')[1]);
        }
      }
      widget.requestOptions.requestQuery.queryParams
          .removeWhere((key, value) => !splitNewOptions.contains(key));
    }

    Widget getOptionPage(String requestHeading) {
      switch (requestHeading) {
        case 'requestBody':
          return RenderRequestBody(
            requestOptions: widget.requestOptions,
            updateRequestOptions: updateRequestOptions,
          );
        case 'auth':
          return RenderRequestAuth(
              requestOptions: widget.requestOptions,
              onUpdated: updateRequestOptions);
        case 'requestQuery':
          return RenderRequestQuery(
            requestQuery: widget.requestOptions.requestQuery,
            context: context,
            requestUrl: widget.requestUrl,
            updateUrl: widget.updateUrl,
          );
        case 'requestHeaders':
          return RenderRequestHeader(
            headers:
                Map<String, String>.from(widget.requestOptions.requestHeaders),
            onHeadersChanged: (newHeaders) {
              setState(() {
                widget.requestOptions.requestHeaders = newHeaders;
              });
            },
            context: context,
          );
        default:
          return Text('$requestHeading to be implemented');
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 5,
          child: DefaultTabController(
            length: optionKeys.length,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  padding: const EdgeInsets.all(2.0),
                  child: TabBar(
                      tabs: requestOptionHeadings
                          .map(
                            (e) => Tab(
                                text: e.replaceRange(0, 1, e[0].toUpperCase())),
                          )
                          .toList()),
                ),
                Expanded(
                  child: TabBarView(
                    children: optionKeys
                        .map<Widget>((key) => getOptionPage(key))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
