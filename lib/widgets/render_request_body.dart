import 'package:flutter/material.dart';
import 'package:phlitt/model/collections_model.dart';
import 'package:phlitt/widgets/render_multipart_form_body.dart';

class RenderRequestBody extends StatefulWidget {
  final RequestOptions requestOptions;
  final Function updateRequestOptions;
  const RenderRequestBody(
      {super.key,
      required this.updateRequestOptions,
      required this.requestOptions});

  @override
  State<RenderRequestBody> createState() => _RenderRequestBodyState();
}

class _RenderRequestBodyState extends State<RenderRequestBody> {
  Widget renderRequestBody() {
    final TextEditingController bodyController = TextEditingController(
        text: widget.requestOptions.requestBody.bodyValue as String?);

    final TextEditingController bodyTypeController =
        TextEditingController(text: widget.requestOptions.requestBody.bodyType);

    return Column(
      children: [
        DropdownMenu(
          controller: bodyTypeController,
          onSelected: (value) => setState(() =>
              widget.requestOptions.requestBody.bodyType = value as String),
          dropdownMenuEntries: ['x-www-form-urlencoded', 'json']
              .map((e) => DropdownMenuEntry(label: e, value: e))
              .toList(),
        ),
        widget.requestOptions.requestBody.bodyType == 'x-www-form-urlencoded'
            ? Expanded(
                child: RenderMultipartFormBody(
                    requestOptions: widget.requestOptions))
            : TextFormField(
                controller: bodyController,
                onChanged: (value) =>
                    widget.requestOptions.requestBody.bodyValue = value,
                maxLines: null,
              ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return renderRequestBody();
  }
}
