import 'package:flutter/material.dart';
import 'package:qapic/widgets/render_request_body.dart';
import 'package:qapic/widgets/render_request_auth.dart';
import 'package:qapic/widgets/render_request_query.dart';
import 'package:qapic/model/collections_model.dart';

class RenderRequestOptions extends StatefulWidget {
  final RequestOptions requestOptions;
  final String requestUrl;

  const RenderRequestOptions({super.key, required this.requestOptions, required this.requestUrl});

  @override
  State<RenderRequestOptions> createState() => _RenderRequestOptionsState();
}

class _RenderRequestOptionsState extends State<RenderRequestOptions> {
  @override
  Widget build(BuildContext context) {
    List<String> requestOptionHeadings = widget.requestOptions.toJson().keys.toList();

    updateRequestOptions(List<String> newOptions) {
      List<String> splitNewOptions = [];
      for(var option in newOptions){
        if(option.startsWith(':')){
          splitNewOptions.add(option.split(':')[1]);
        }
      }
      widget.requestOptions.requestQuery.queryParams.removeWhere((key, value) => !splitNewOptions.contains(key));
    }

    Widget getOptionPage(String requestHeading) {
      switch (requestHeading) {
        case 'requestBody':
          return RenderRequestBody(
            existingRequestOptions: widget.requestOptions,
            updateRequestOptions: updateRequestOptions,
          );
        case 'auth':
          return RenderRequestAuth(
              requestOptions: widget.requestOptions, onUpdated: updateRequestOptions);
        case 'requestQuery':
          return RenderRequestQuery(
            requestQuery: widget.requestOptions.requestQuery, context: context, requestUrl: widget.requestUrl, updateRequestQuery: updateRequestOptions,
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
              length: requestOptionHeadings.length,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2.0),
                    child: TabBar(
                        tabs: requestOptionHeadings
                            .map(
                              (e) => Tab(
                                  text:
                                      e.replaceRange(0, 1, e[0].toUpperCase())),
                            )
                            .toList()),
                  ),
                  Expanded(
                    child: TabBarView(
                        children: widget.requestOptions
                            .toJson()
                            .keys
                            .map<Widget>((key) => getOptionPage(key))
                            .toList()),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
