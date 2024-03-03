import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  final Iterable collection;
  final String collectionName;

  const MainPage(
      {super.key, required this.collection, required this.collectionName});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String selectedCollection =''; 
  Iterable collection = [];

  @override
  Widget build(BuildContext context) {
    selectedCollection = widget.collectionName;
    collection = widget.collection;
    return Column(
      children: [
        Text(selectedCollection),
        Text(collection.toString()),
      ],
    );
  }
}
