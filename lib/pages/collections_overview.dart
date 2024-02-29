import 'package:flutter/material.dart';

class CollectionChanged extends Notification {
  final String val;
  CollectionChanged(this.val);
}

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      const Text('Teapot'),
      FloatingActionButton(onPressed: () {
        CollectionChanged('Collection').dispatch(context);
      })
    ]));
  }
}
