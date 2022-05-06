import 'dart:io';

import 'package:fencegate/main.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
//This class will be used in the future, but for now, it wont be used
class Database {

  static final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  //This function synchronize the base and database levels.
  static Future<void> downloadNewLevels() async {
    try {
      await storage.ref('level/').list().then((value) async {
        List<firebase_storage.Reference> items =value.items;

        if(items.length==Data.levelLength){
          print("Same directories in base and database. Downloaded 0 files");
          return;
        }

        if(items.length<Data.levelLength){
          print("More directories in base than in database. Removing corresponding files");
          List<Directory> directories = Data.levels;
          List<Directory> commonBaseDataBaseDirectories = List.empty(growable: true);
          for(firebase_storage.Reference ref in items){
            for(Directory dir in directories){
                if(int.parse(ref.name.substring(3)) == int.parse(_getNamefromDirectory(dir).substring(3))){
                  commonBaseDataBaseDirectories.add(dir);
                }
            }
          }
          commonBaseDataBaseDirectories.forEach((element) {
            directories.remove(element);
          });

          directories.forEach((element) {
            File(element.path).delete();
          });
          await Data.reload();
          return;
        }

        print("More files in database than in base. Downloading new files.");
        for(firebase_storage.Reference element in items) {
          if(isInStorage(element)) {
            continue;
          }
          print("Downloading file ${element.name}");
          File f = File("${Data.levelDir.path}/${element.name}");
          if(!await f.exists()){
            await f.create();
            element.writeToFile(f);
            print("File ${f.path} created");
            continue;
          }
          print("File ${f.path} no created, already exist");
        }
        await Data.reload();
      });
    } on firebase_storage.FirebaseException catch (e) {
        print(e);
    }
  }

  //Used to get the name of a location or a directory
  static String _getNamefromDirectory(Directory dir) {
    return dir.path.replaceAll(dir.parent.path, "").substring(1);
  }

  //Used to know if an element is in local storage or no.
  static bool isInStorage(firebase_storage.Reference element) {
    for(int i = 0;i<Data.levelLength;i++){
      if(int.parse(element.name.substring(3)) == int.parse(_getNamefromDirectory(Data.levels[i]).substring(3))){
        return true;
      } 
    }
    return false;
  }
}