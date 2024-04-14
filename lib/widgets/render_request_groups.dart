import 'package:flutter/material.dart';

class AddToCollection extends Notification {
  final List requestGroups;
  AddToCollection(this.requestGroups);
}

class OpenSelectedRequest extends Notification {
  final String requestName;
  OpenSelectedRequest(this.requestName);
}

class RenderRequestGroups extends StatelessWidget {
  final List requestGroups;
  final String parentListName;
  final Function(String) selectRequest;

  const RenderRequestGroups(
      {super.key, required this.requestGroups, required this.parentListName, required this.selectRequest});

  Widget renderList(listToRender, listName) {
    int lastItem = listToRender.length;
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: listToRender.length + 1,
        itemBuilder: (context, index) {
          if (index == lastItem) {
            return IconButton(
              onPressed: () => AddToCollection(listToRender),
              icon: const Icon(Icons.add),
            );
          } else if (listName == 'requestGroupName') {
            return ExpansionTile(
              title: Text(listToRender[index][listName]),
              children: [
                renderList(listToRender[index]['requests'], 'requestName')
              ],
            );
          } else {
            return TextButton(
              child: Text(listToRender[index]['requestName']),
              onPressed: () => selectRequest(listToRender[index]['requestName']),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return renderList(requestGroups, parentListName);
  }
}
