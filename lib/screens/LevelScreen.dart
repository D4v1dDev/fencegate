import 'package:fencegate/objects/Board.dart';
import 'package:fencegate/screens/LevelSelectorScreen.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class LevelScreen extends StatefulWidget {
  const LevelScreen({Key? key}) : super(key: key);

  @override
  _LevelScreenState createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  @override
  Widget build(BuildContext context) {
    Board b=Board.fromLevelNumberInDatabase(LevelSelectorScreen.selectedLevel);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${Data.getText(3)} #${LevelSelectorScreen.selectedLevel}"),
      ),
      body: SafeArea(
        child: Center(
          child: StreamBuilder(stream : b.controller.stream,builder: (c, s) {
                  //Executed when the level can't be loaded correctly
                  if(!s.hasData){
                    return CircularProgressIndicator();
                  }

                  //Executed when the player wins
                  if(s.connectionState==ConnectionState.done){
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        s.data as Widget,
                        AlertDialog(
                          title: Text("${Data.getText(3)} #${LevelSelectorScreen.selectedLevel}"),
                          elevation: 5,
                          content: Text("${Data.getText(4)}"),
                          actions: [
                            ElevatedButton(
                              onPressed: ()=>Navigator.pop(context),
                              child: Text("${Data.getText(5)}"),),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if(!LevelSelectorScreen.nextLevel()){
                                    Navigator.pop(context);
                                  }else{
                                    Navigator.popAndPushNamed(context, "/lvl");
                                  }
                                });
                              },
                              child: Text("${Data.getText(6)}"),)
                          ],
                        ),
                      ],
                    );
                  }

                  //Executed regularly
                  return s.data as Widget;
          })
        ),
      ),
    );
  }
}
