import 'package:flutter/material.dart';

import 'screens/LevelScreen.dart';
import 'screens/LevelSelectorScreen.dart';
import 'screens/MainScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
