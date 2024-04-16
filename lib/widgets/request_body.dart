import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RequestBody extends StatelessWidget {
  final String existingRequestBody;
  final Function updateRequestOptions;
  RequestBody(
      {super.key, required this.updateRequestOptions, required this.existingRequestBody}
    );

  final TextEditingController bodyController = TextEditingController();

  Widget requestBody() {
    return Text(existingRequestBody);
  }

  @override
  Widget build(BuildContext context) {
    return requestBody();
  }
}