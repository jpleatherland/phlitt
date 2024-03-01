import 'package:path_provider/path_provider.dart';

import 'dart:io';
import 'dart:convert';

class CollectionsManager {  
  
  String collectionTemplate = '''{
    "collections": [
      {
        "collectionName": "example",
        "requestGroups": [
          {
            "requestGroupName": "exampleGroup",
            "requests": [
              {
                "requestName": "exampleRequest"
              }
            ]
          }
        ]
      }
    ]
  }''';
  
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    final bool exists = await File('$path/collection.json').exists();
    if (exists) {
      return File('$path/collection.json');
    } else {
      File file = File('$path/collections.json');
      file.writeAsString(collectionTemplate);
      return File('$path/collections.json');
    }
  }

  Future<Map<String, dynamic>> readCollectionsFile() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      final collections = jsonDecode(contents) as Map<String, dynamic>;
      return collections;
    } catch (error) {
      return {};
    }
  }

  Future<File> writeCollections(Map collection) async {
    final file = await _localFile;

    return file.writeAsString('$collection');
  }
}
