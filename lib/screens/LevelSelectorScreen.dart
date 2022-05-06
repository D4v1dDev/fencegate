import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LevelSelectorScreen extends StatelessWidget {
  LevelSelectorScreen({Key? key}) : super(key: key);

  static int _selectedLevel = 0;

  static int get selectedLevel => _selectedLevel;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: SafeArea(
            child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemCount: 28,
                  itemBuilder: (c,index){
                    Future<Color> ca =_isCompleted(index).then((value) async {
                      if(index == 0 || value){
                        return Colors.lightGreen;
                      }
                      if(await _isCompleted(index+1)){
                        return Colors.yellow;
                      }
                      return Colors.grey;
                    });
                    Color c = Colors.grey;
                    ca.then((value) => c=value);
                    return Padding(
                      padding: EdgeInsets.all(5),
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(c)),
                        onPressed: () async {
                          if(index==0 || await _isCompleted(index)){
                              _selectedLevel = index+1;
                              Navigator.pushNamed(context, '/lvl');
                          }
                        },
                        child: Text("#${index+1}"),
                      ),
                    );
                  }
          ),
        ),
    );
  }

  static bool nextLevel() {
    if(_selectedLevel>9){
      return false;
    }
    _selectedLevel++;
    return true;
  }

  Future<bool> _isCompleted(int index) async {
    if(index == 0) return false;
    return await rootBundle.loadString('res/level/lvl$index').then((value) => jsonDecode(value)["completed"]);
  }
}