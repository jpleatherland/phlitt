import 'package:flutter/material.dart';
import 'package:qapic/model/collections_model.dart';
import 'package:flutter_editable_table/flutter_editable_table.dart';

class RenderRequestQuery extends StatelessWidget {
  final RequestQuery requestQuery;
  final BuildContext context;

  const RenderRequestQuery({super.key, required this.requestQuery, required this.context});



  Widget renderQueryOptions() {
    final queryTableData = {
    "column_count": 2,
    "row_count": requestQuery.queryParams.length,
    "addable": true,
    "removeable": true,
    "caption": {
      "main_caption": {
        "title": "Query Parameters",
        "editable": false
      }
    },
    "columns": [
      {
        "primary_key": true,
        "name": "Query Parameter",
        "type": "String",
        "editable": true,
        "display": true,
        "style": {
          "font_weight": "bold",
          "font_size": 14.0,
          "font_color": "#000000",
          "background_color": Theme.of(context).colorScheme.secondary,
          "horizontal_alignment": "center",
          "vertical_alignment": "center",
          "text_align": "center"
        }
      },
      {
        "name": "Value",
        "type": "String",
        "editable": true
      }
    ],
    "rows": requestQuery.queryParams.entries
  };
    return EditableTable(
          key: Key('nice key'),
          data: queryTableData,
          readOnly: false,
          tablePadding: EdgeInsets.all(8.0),
          captionBorder: Border(
            top: BorderSide(color: Color(0xFF999999)),
            left: BorderSide(color: Color(0xFF999999)),
            right: BorderSide(color: Color(0xFF999999)),
          ),
          headerBorder: Border.all(color: Color(0xFF999999)),
          rowBorder: Border.all(color: Color(0xFF999999)),
          footerBorder: Border.all(color: Color(0xFF999999)),
          removeRowIcon: Icon(
            Icons.remove_circle_outline,
            size: 24.0,
            color: Colors.redAccent,
          ),
          addRowIcon: Icon(
            Icons.add_circle_outline,
            size: 24.0,
            color: Colors.white,
          ),
          addRowIconContainerBackgroundColor: Colors.blueAccent,
          formFieldAutoValidateMode: AutovalidateMode.always,
          onRowRemoved: (row) {
            print('row removed: ${row.toString()}');
          },
          onRowAdded: () {
            print('row added');
          },
    );
  }

  @override
  Widget build(BuildContext context) {
    return renderQueryOptions();
  }
}
