import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  final Map<String, dynamic> collections;
  final String selectedCollection;

  const MainPage({super.key, required this.collections, required this.selectedCollection});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Hello'),
      ],
    );
  }
}
