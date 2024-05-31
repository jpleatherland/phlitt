import 'package:flutter/material.dart';

class RenderResponse extends StatelessWidget {
  const RenderResponse({
    super.key,
    required this.responseData,
    required this.isFetching,
  });

  final Map<String, dynamic> responseData;
  final bool isFetching;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Status Code: ${responseData['statusCode']}',
          textAlign: TextAlign.right,
        ),
        isFetching
            ? const Center(child: CircularProgressIndicator())
            : Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Expanded(
                  child: SingleChildScrollView(
                    child: SelectableText(
                      responseData['body'] as String,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
            ),
      ],
    );
  }
}
