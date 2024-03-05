import 'package:flutter/material.dart';

class RenderRequestGroups extends StatelessWidget {
  final List requestGroups;

  const RenderRequestGroups({super.key, required this.requestGroups});
  
  Widget renderRequestGroups(listToRender) {
    int lastItem = listToRender.length;
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: listToRender.length + 1,
        itemBuilder: (context, index) {
          if (index == lastItem) {
            return TextButton.icon(
              label: const Text('Add Request Group'),
              onPressed: () => print('hi'), //_dialogBuilder(context),
              icon: const Icon(Icons.add),
            );
          } else {
            return ExpansionTile(
              title: Text(listToRender[index]['requestGroupName']),
              children: [renderList(listToRender[index]['requests'])],
            );
          }
        });
  }

  Widget renderList(listToRender) {
    int lastItem = listToRender.length;
    return ListView.builder(
      itemCount: listToRender.length + 1,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index == lastItem) {
          return TextButton.icon(
            label: const Text('Add Request'),
            onPressed: () => print('add request'),
            icon: const Icon(Icons.add),
          );
        } else {
          return TextButton(
            child: Text(listToRender[index]['requestName']),
            onPressed: () => print('Pressed'),
          );
        }
      },
    );
  }
  @override
    Widget build(BuildContext context) {
      return renderRequestGroups(requestGroups);
    }
}
