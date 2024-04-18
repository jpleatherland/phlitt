import 'package:flutter/material.dart';
import 'package:flutter_editable_table/flutter_editable_table.dart';

class QueryOptions extends StatelessWidget {
  final String existingRequestBody;
  final Function updateRequestOptions;

  const QueryOptions(
      {super.key,
      required this.updateRequestOptions,
      required this.existingRequestBody});

  Widget queryOptions() {
    return EditableTable();
  }

  @override
  Widget build(BuildContext context) {
    return queryOptions();
  }
}
