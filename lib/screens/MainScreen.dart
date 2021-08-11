import 'dart:math';

import 'package:fencegate/objects/Board.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var board = Board.fromLevelNumber(2);

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: StreamBuilder(stream:board.controller.stream,builder: (c,s){
              Future.delayed(Duration(seconds: Random().nextInt(3)+2)).whenComplete(() => board.shuffle());
              if(s.connectionState==ConnectionState.active){
                board.block();
                return s.data as Widget;
              }
              return CircularProgressIndicator();
            }),
          ),
          SafeArea(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 125,),
                    Image.asset("res/icons/title.png"),
                    SizedBox(height: 70,),
                    ElevatedButton(onPressed: (){Navigator.of(context).pop("/");Navigator.pushNamed(context, "/lvlSelector");}, style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),), child:Padding(padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Text("JUGAR",style: TextStyle(fontSize: 30,color: Colors.black),)),),
                    SizedBox(height: 20,),
                    ElevatedButton(onPressed: (){Navigator.of(context).pop("/settings");}, style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),), child:Padding(padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Text("OPCIONES",style: TextStyle(fontSize: 30,color: Colors.black),)),),
                  ],
                ),
              ),
          ),
        ],
      ),
    );
  }
}

