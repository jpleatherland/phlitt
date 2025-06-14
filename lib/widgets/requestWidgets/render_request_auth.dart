import 'package:flutter/material.dart';
import 'package:phlitt/model/collections_model.dart';

class RenderRequestAuth extends StatelessWidget {
  final RequestOptions requestOptions;
  final Function onUpdated;
  final List<String> authTypeOptions = ['ApiKey', 'Basic', 'Bearer', 'No Auth'];

  RenderRequestAuth(
      {super.key, required this.requestOptions, required this.onUpdated}) {
    print(
        'RenderRequestAuth constructor: authType = \\${requestOptions.auth.authType}');
  }

  @override
  Widget build(BuildContext context) {
    print(
        'RenderRequestAuth build: authType = \\${requestOptions.auth.authType}');
    return Column(
      children: [
        DropdownMenu(
            initialSelection: requestOptions.auth.authType,
            dropdownMenuEntries: authTypeOptions
                .map((e) => DropdownMenuEntry(value: e, label: e))
                .toList(),
            onSelected: (value) =>
                requestOptions.auth.authType = value as String),
        TextFormField(
          initialValue: requestOptions.auth.authValue,
          onChanged: (value) => requestOptions.auth.authValue = value,
          onFieldSubmitted: (value) => requestOptions.auth.authValue = value,
        )
      ],
    );
  }
}
