import 'package:flutter/material.dart';
import 'package:qapic/model/collections_model.dart';

class RenderRequestQuery extends StatelessWidget {
  final RequestQuery requestQuery;
  final BuildContext context;

  const RenderRequestQuery({super.key, required this.requestQuery, required this.context});

  void updateRequestQuery(){
  }

  Widget renderQueryOptions() {
	//read the url
	//get things surrounded by {}
	//get things beginning with :
	//list out the keys followed by a text field and a save icon
	//on save, write the k:v to the request query body
  }

  @override
  Widget build(BuildContext context) {
    return renderQueryOptions();
  }
}
