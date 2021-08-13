import 'dart:io';

import 'package:fencegate/main.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Database {
  static final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  static Future<void> downloadFileExample() async {
    try {
      storage.ref("level/").list().then((value) => print(value.items.length));
      await storage.ref('level/').list().then((value) {
        value.items.forEach((element) async {
          File f = File("${Data.level_dir.path}/${element.name}");
          if(!await f.exists()){
            await f.create();
            element.writeToFile(f);
            print("File ${f.path} created");
            return;
          }else{
            /*TODO
            DELETE the content in else when finish the database bugfixing
            this line just recharge all the files and that makes that the
            database reads increase.
             */
            await f.delete();
            await f.create();
            element.writeToFile(f);
          }
          print("File ${f.path} no created, already exist");
        });
      });
    } on firebase_storage.FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
    }
  }

}