import 'package:flutter/material.dart';

class RequestAuth extends StatelessWidget {
  final String authType;
  final String authValue;
  final Function onUpdated;
  final List<String> authTypeOptions = ['Basic Auth', 'Bearer Token', 'No Auth'];

  RequestAuth({super.key, required this.authType, required this.authValue, required this.onUpdated});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownMenu(
          initialSelection: authType,
          dropdownMenuEntries: authTypeOptions.map((e) => DropdownMenuEntry(value: e, label: e)).toList(),
          onSelected: (value) => onUpdated({'auth':{ 'authType': value }}),)
      ],
    );
  }
}