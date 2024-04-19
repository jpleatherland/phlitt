import 'package:flutter/material.dart';
import 'package:qapic/model/collections_model.dart';

class RenderRequestAuth extends StatelessWidget {
  final Auth auth;
  final Function onUpdated;
  final List<String> authTypeOptions = ['Basic Auth', 'Bearer Token', 'No Auth'];

  RenderRequestAuth({super.key, required this.auth, required this.onUpdated});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownMenu(
          initialSelection: auth.authType,
          dropdownMenuEntries: authTypeOptions.map((e) => DropdownMenuEntry(value: e, label: e)).toList(),
          onSelected: (value) => onUpdated({'auth':{ 'authType': value }}),)
      ],
    );
  }
}