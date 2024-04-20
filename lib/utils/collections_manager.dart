import 'package:path_provider/path_provider.dart';

import 'dart:io';
import 'dart:convert';

import 'package:qapic/model/collections_model.dart';
import './example_collection.dart';

mixin class CollectionsManager {  

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    final bool exists = await File('$path/collections.json').exists();
    if (exists) {
      return File('$path/collections.json');
    } else {
      File file = File('$path/collections.json');
      file.writeAsString(collectionTemplate);
      return File('$path/collections.json');
    }
  }

  Future<CollectionGroup> readCollectionsFile() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      final collections = jsonDecode(contents) as Map<String, dynamic>;
      final collectionToReturn = CollectionGroup.fromJson(collections);
      return collectionToReturn;
    } catch (error) {
      throw Exception(error);
    }
  } 

  Future<void> writeCollections(CollectionGroup collection) async {
    final file = await _localFile;
    final dataToEncode = collection.toJson(collection);
    final contents = jsonEncode(dataToEncode);
    final firstRead = await file.readAsString();
    print(firstRead.toString());

    await file.writeAsString(contents);
    final secondRead = await file.readAsString();
    print(secondRead.toString());
    print('done');

  }
}