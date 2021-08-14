import 'dart:io';

import 'package:fencegate/main.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Database {
  static final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  static Future<void> downloadNewLevels() async {
    try {
      await storage.ref('level/').list().then((value) async {
        List<firebase_storage.Reference> items =value.items;

        print("${Data.LEVEL_LENGTH} ${items.length}");
        if(items.length<=Data.LEVEL_LENGTH){
          return;
        }


        for(firebase_storage.Reference element in items) {
          if(int.parse(element.name.substring(3)) <= Data.LEVEL_LENGTH){
            continue;
          }
          print("Downloading file ${element.name}");
          File f = File("${Data.level_dir.path}/${element.name}");
          if(!await f.exists()){
            await f.create();
            element.writeToFile(f);
            print("File ${f.path} created");
            return;
          }
          print("File ${f.path} no created, already exist");
        }

      });
    } on firebase_storage.FirebaseException catch (e) {
        print(e);
    }
  }

}