import 'package:flutter/material.dart';
import 'package:qapic/model/collections_model.dart';

class RenderRequestGroups extends StatelessWidget {
  final List<RequestGroup> requestGroups;
  final String parentListName;
  final Function(Map<String, dynamic>) selectRequest;

  const RenderRequestGroups(
      {super.key, required this.requestGroups, required this.parentListName, required this.selectRequest});

  Widget renderList(List<dynamic> listToRender, listName) {
    int lastItem = listToRender.length;
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: listToRender.length + 1,
        itemBuilder: (context, index) {
          if (index == lastItem) {
            return IconButton(
              onPressed: () => print('add to collection'),
              icon: const Icon(Icons.add),
            );
          } else if (listName == 'requestGroupName') {
            return ExpansionTile(
              title: Text(listToRender[index][listName] as String),
              children: [
                renderList(listToRender[index]['requests'] as List<dynamic>, 'requestName')
              ],
            );
          } else {
            return TextButton(
              child: Text(listToRender[index]['requestName'] as String),
              onPressed: () => selectRequest(listToRender[index] as Map<String, dynamic>),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return renderList(requestGroups as List<dynamic>, parentListName);
  }
}
