import 'package:flutter/material.dart';

class RequestBody extends StatelessWidget {
  final String existingRequestBody;
  final Function updateRequestOptions;
  const RequestBody(
      {super.key,
      required this.updateRequestOptions,
      required this.existingRequestBody});

  Widget requestBody() {
    final TextEditingController bodyController =
        TextEditingController(text: existingRequestBody);

    //put a data table in here
    return TextField(
      controller: bodyController,
      maxLines: null,
      onChanged: (value) => updateRequestOptions({'body':bodyController.text}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return requestBody();
  }
}
