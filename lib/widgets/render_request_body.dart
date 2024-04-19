import 'package:flutter/material.dart';
import 'package:qapic/model/collections_model.dart';

class RenderRequestBody extends StatelessWidget {
  final RequestOptions existingRequestOptions;
  final Function updateRequestOptions;
  const RenderRequestBody(
      {super.key,
      required this.updateRequestOptions,
      required this.existingRequestOptions});

  Widget renderRequestBody() {
    final TextEditingController bodyController =
        TextEditingController(text: existingRequestOptions.requestBody.bodyValue['body'] as String);

    void doAThing(value) {
      existingRequestOptions.requestBody.bodyValue['body'] = value as String;
      updateRequestOptions(existingRequestOptions);
    }

    //put a data table in here
    return TextField(
      controller: bodyController,
      maxLines: null,
      onChanged: (value) => doAThing(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return renderRequestBody();
  }
}
