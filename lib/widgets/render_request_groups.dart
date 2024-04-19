import 'package:flutter/material.dart';
import 'package:qapic/model/collections_model.dart';

class RenderCollectionRequestGroups extends StatelessWidget {
  final Collection collection;
  final Function(Request) selectRequest;

  const RenderCollectionRequestGroups(
      {super.key, required this.collection, required this.selectRequest});

  Widget renderCollectionRequestGroups(
      Collection collection, Function selectRequest) {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: collection.requestGroups.length,
        itemBuilder: (BuildContext context, int index) {
          return ExpansionTile(
              title: Text(collection.requestGroups[index].requestGroupName),
              children: collection.requestGroups[index].requests
                  .map((e) => TextButton.icon(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                        ),
                        // dense: true,
                        // trailing: const Icon(Icons.navigate_next),
                        onPressed: () => selectRequest(e),
                        icon: Text(e.requestName),
                        label: const Icon(Icons.arrow_forward_ios, size: 14),
                      ))
                  .toList()
              // renderRequestNames(collection.requestGroups[index].requests),
              );
        });
  }

  @override
  Widget build(BuildContext context) {
    return renderCollectionRequestGroups(collection, selectRequest);
  }
}
