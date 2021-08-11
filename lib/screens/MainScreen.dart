import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blueAccent,
                      Colors.red
                    ]
                ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset("res/icons/fondo.png"),
          ),
          SafeArea(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 150,),
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

