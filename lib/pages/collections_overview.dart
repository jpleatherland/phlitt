import 'package:flutter/material.dart';

class CollectionChanged extends Notification {
  final String val;
  CollectionChanged(this.val);
}

class CollectionsPage extends StatelessWidget {

  final List collections;
  const CollectionsPage({super.key, required this.collections});

  @override
  Widget build(BuildContext context) {
    return 
      Text(collections.toString());
  }
}
