import 'package:flutter/material.dart';

class LevelSelectorScreen extends StatelessWidget {
  LevelSelectorScreen({Key? key}) : super(key: key);

  static int _selectedLevel = 0;

  static int get selectedLevel => _selectedLevel;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Image.asset("res/icons/title.png"),
              Expanded(
                child: ListView.builder(itemCount: 10,itemBuilder: (c,i) {


                  return Padding(padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                      child: ElevatedButton(
                          onPressed: () {
                            _selectedLevel = i + 1;
                            Navigator.pushNamed(context, "/lvl");
                            },
                          child: Text("Acceder a nivel ${i + 1}")));
                  }
                ),
              )
            ],
          ),
        )
    );
  }

  static bool nextLevel() {
    if(_selectedLevel>9){
      return false;
    }
    _selectedLevel++;
    return true;
  }
}