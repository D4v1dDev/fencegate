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
        if(items.length==Data.LEVEL_LENGTH){
          return;
        }

        if(items.length<Data.LEVEL_LENGTH){
          List<Directory> directories = Data.levels;
          List<Directory> da = List.empty(growable: true);
          for(firebase_storage.Reference ref in items){
            for(Directory dir in directories){
                if(int.parse(ref.name.substring(3)) == int.parse(_getNamefromDirectory(dir).substring(3))){
                  da.add(dir);
                }
            }
          }
          da.forEach((element) {
            directories.remove(element);
          });

          directories.forEach((element) {
            File(element.path).delete();
          });
          await Data.reload();
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
        await Data.reload();
      });
    } on firebase_storage.FirebaseException catch (e) {
        print(e);
    }
  }

  static String _getNamefromDirectory(Directory dir) {
    return dir.path.replaceAll(dir.parent.path, "").substring(1);
  }
}