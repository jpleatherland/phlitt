import 'package:flutter/material.dart';
import 'package:qapic/model/collections_model.dart';

class RenderRequestBody extends StatelessWidget {
  final RequestBody existingRequestBody;
  final Function updateRequestOptions;
  const RenderRequestBody(
      {super.key,
      required this.updateRequestOptions,
      required this.existingRequestBody});

  Widget renderRequestBody() {
    final TextEditingController bodyController =
        TextEditingController(text: existingRequestBody.bodyValue['body'] as String);

    //put a data table in here
    return TextField(
      controller: bodyController,
      maxLines: null,
      onChanged: (value) => updateRequestOptions({'body':bodyController.text}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return renderRequestBody();
  }
}
