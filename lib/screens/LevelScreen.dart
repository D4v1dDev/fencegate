import 'package:fencegate/objects/Board.dart';
import 'package:fencegate/screens/LevelSelectorScreen.dart';
import 'package:flutter/material.dart';

class LevelScreen extends StatefulWidget {
  const LevelScreen({Key? key}) : super(key: key);

  @override
  _LevelScreenState createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Level #${LevelSelectorScreen.selectedLevel}"),
      ),
      body: SafeArea(
        child: Center(
          child: StreamBuilder(stream : Board.fromLevelNumber(LevelSelectorScreen.selectedLevel).controller.stream,builder: (c, s) {
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
                          title: Text("Level #${LevelSelectorScreen.selectedLevel}"),
                          elevation: 5,
                          content: Text("You Won!"),
                          actions: [
                            ElevatedButton(
                              onPressed: ()=>Navigator.pop(context),
                              child: Text("Return To Level Page"),),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if(!LevelSelectorScreen.nextLevel()){
                                    Navigator.pop(context);
                                  }
                                });
                              },
                              child: Text("Next Level"),)
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
