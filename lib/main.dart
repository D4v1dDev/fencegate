import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


import 'firebase/Database.dart';
import 'screens/LevelScreen.dart';
import 'screens/LevelSelectorScreen.dart';
import 'screens/MainScreen.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Data.init().whenComplete(()async => await Firebase.initializeApp().whenComplete(() => Database.downloadNewLevels()));
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Fencegate",
    initialRoute: "/",
    routes: {
      "/" : (context) => MainScreen(),
      "/lvlSelector" : (context) => LevelSelectorScreen(),
      "/lvl" : (context) => LevelScreen(),
    }));
}


class Data {

  static late final int LEVEL_LENGTH;

  static late final Directory main_dir;
  static late final Directory level_dir;
  static late final List<Directory> levels;

  static Future<void> init() async {
    main_dir = await getApplicationDocumentsDirectory();
    level_dir = Directory("${main_dir.path}/level");

    var temp = await level_dir.list().toList();

    levels= List.generate(temp.length, (index) => Directory(temp[index].path));
    level_dir.exists().then((exist) async {
      if(exist){
        LEVEL_LENGTH=await level_dir.list().length;
      }else{
        level_dir.create();
        LEVEL_LENGTH=0;
      }
    });
  }

}