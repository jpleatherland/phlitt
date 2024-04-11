import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'dart:io';
import 'dart:convert';

import './example_collection.dart' as exc;

class CollectionsManager {  

  static const url = 'http://0.0.0.0:8000';
  
  // Future<String> get _localPath async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   return directory.path;
  // }

  // local file
  // Future<File> get _localFile async {
  //   final path = await _localPath;
  //   final bool exists = await File('$path/collections.json').exists();
  //   if (exists) {
  //     return File('$path/collections.json');
  //   } else {
  //     File file = File('$path/collections.json');
  //     file.writeAsString(collectionTemplate);
  //     return File('$path/collections.json');
  //   }
  // }

  Future<Object> get _getServerFile async {
    final collectionsFile = await http.get(Uri.parse(url));
    if (collectionsFile.statusCode == 404){
      writeCollections(exc.collectionTemplate as Map);
    }
    return collectionsFile;
  }
  // local file
  // Future<Map<String, dynamic>> readCollectionsFile() async {
  //   try {
  //     final file = await _localFile;
  //     final contents = await file.readAsString();
  //     final collections = jsonDecode(contents) as Map<String, dynamic>;
  //     return collections;
  //   } catch (error) {
  //     return {};
  //   }
  // }

    Future<Map<String, dynamic>> readCollectionsFile() async {
    try {
      final file = await _getServerFile;
      return file as Map<String, dynamic>;
    } catch (error) {
      return {};
    }
  }

  Future<void> writeCollections(Map collection) async {
    http.post(Uri.parse(url), body:{Object: collection});
  }
}