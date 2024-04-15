import 'package:flutter/material.dart';

class TabData extends StatelessWidget {
  final Map<String, dynamic> request;
  const TabData({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    return Text(request['requestName']);
  }
}