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

  static int levelLength=0;

  static late final Directory mainDir;
  static late final Directory levelDir;
  static late List<Directory> levels;

  //LANGUAGES
  //0:English
  //1:Spanish
  //Index                                  0        1           2             3         4               5                         6                   7
  static const List<List<String>> _TEXT = [["Play", "Settings",  "Access to ",  "Level",  "Winner!",      "Return to level page", "Next level",       "Language"],
                                          ["Jugar", "Opciones", "Acceder a ", "Nivel",  "¡Has ganado!",   "Volver",               "Siguiente nivel",  "Idioma"]];
  static int _language = 1;
  static Image languageIcon=Image.asset("res/icons/lang/sp.png");

  static Future<void> init() async {
    mainDir = await getApplicationDocumentsDirectory();
    levelDir = Directory("${mainDir.path}/level");

    await reload();
  }

  static reload() async {

    levelDir.exists().then((exist) async {
      if(exist){
        levelLength=await levelDir.list().length;
      }else{
        await levelDir.create();
        levelLength=0;
      }
    });

    var temp = await levelDir.list().toList();

    levels= List.generate(temp.length, (index) => Directory(temp[index].path));

  }

  static void changeLanguage() {
    _language++;
    _language%=_TEXT.length;
    switch(_language){
      case 0:
        languageIcon = Image.asset('res/icons/lang/eu.png');
        break;
      case 1:
        languageIcon = Image.asset('res/icons/lang/sp.png');
    }
  }
  
  static String getText(final int index){
    return _TEXT[_language][index];
  }

  static Route _createRoute(final Widget w) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => w,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}