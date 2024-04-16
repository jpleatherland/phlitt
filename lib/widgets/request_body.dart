import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RequestBody extends StatelessWidget {
  final Map<String, dynamic> existingRequestBody;
  final Function updateRequestOptions;
  RequestBody(
      {super.key,
      required this.updateRequestOptions,
      required this.existingRequestBody});

  final TextEditingController bodyController = TextEditingController();

  Widget requestBody() {
    //put a data table in here
    return Text(existingRequestBody.toString());
  }

  @override
  Widget build(BuildContext context) {
    return requestBody();
  }
}