import 'package:flutter/material.dart';
import 'package:qapic/model/collections_model.dart';

class RenderCollectionRequestGroups extends StatelessWidget {
  final Collection collection;
  final Function(Map<String, dynamic>) selectRequest;

  const RenderCollectionRequestGroups(
      {super.key, required this.collection, required this.selectRequest});

  Widget renderCollectionRequestGroups(Collection collection) {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: collection.requestGroups.length,
        itemBuilder: (BuildContext context, int index) {
          return ExpansionTile(
              title: Text(collection.requestGroups[index].requestGroupName),
              children: collection.requestGroups[index].requests
                  .map((e) => Text(e.requestName))
                  .toList()
              // renderRequestNames(collection.requestGroups[index].requests),
              );
        });
  }

  @override
  Widget build(BuildContext context) {
    return renderCollectionRequestGroups(collection);
  }
}
