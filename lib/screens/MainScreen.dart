import 'package:flutter/material.dart';

import '../main.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 125,),
                    Image.asset("res/icons/title.png"),
                    SizedBox(height: 80,),
                    ElevatedButton(onPressed: (){Navigator.of(context).pop("/");Navigator.pushNamed(context, "/lvlSelector");}, style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),), child:Padding(padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Text("${Data.getText(0).toUpperCase()}",style: TextStyle(fontSize: 30,color: Colors.black),)),),
                    SizedBox(height: 20,),
                    ElevatedButton(onPressed: (){Navigator.of(context).popAndPushNamed("/opts");}, style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),), child:Padding(padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Text("${Data.getText(1).toUpperCase()}",style: TextStyle(fontSize: 30,color: Colors.black),)),),
                  ],
                ),
              ),
          ),
    );
  }
}