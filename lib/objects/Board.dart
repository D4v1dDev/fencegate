import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:fencegate/objects/Section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Board {

  // In spite of the variable type 'dynamic', really it's variable true type is Section
  late final List<List<dynamic>> _sections;
  static const double _BOARD_SIZE=320;
  late final double pieceSize;

  late final StreamController<Widget> _controller ;
  StreamController<Widget> get controller => _controller;

  Board.fromLevelNumber(int num) {
    _controller = StreamController<Widget>();
     rootBundle.loadString("res/level/lvl$num").then((value) {
       List<dynamic> sectionsArray = jsonDecode(value)["sections"];
       List<Section> sect = List.generate(sectionsArray.length, (index) => Section.fromJSON(sectionsArray[index],this));

       _sections=linearToSquareList(sect);
       pieceSize=_BOARD_SIZE/_sections.length;
       build();
     });
  }

  bool isCorrect(){

    for(List<dynamic> row in _sections){
      for(Section section in row)
      if(!section.isCorrectlyPlaced()){
        return false;
      }
    }
    return true;
  }

  void shuffle(){
    for(var row in _sections){
      for(Section sec in row){
        sec.shuffle();
      }
    }
    build();
  }

  List<List<dynamic>> linearToSquareList(List ls){

    List<List> a = List.empty(growable: true);

    int n = sqrt(ls.length).toInt();

    for(int i = 0; i<n;i++){
      List row = List.empty(growable: true);
      for(int j = 0;j<n;j++){
        row.add(ls[i*n+j]);
      }
      a.add(row);
    }

    return a;
  }

  void build() {

    if(_sections.isEmpty) {
      _controller.add(Column(children: [],));
      return;
    }

    List<List<Widget>> sect = List.generate(_sections.length, (index) => List.generate(_sections[index].length, (i) => (_sections[index][i] as Section).getWidget()));

    List<Widget> rows = List.generate(sect.length, (index) => SizedBox(width:(_BOARD_SIZE),child: Row(children: sect[index],)));

    _controller.add(SizedBox(height: (_BOARD_SIZE),child: Column(children: rows)));
  }

  void win() {
    block();
    _controller.close();
  }

  void block() {
    for(List sec in _sections){
      for(Section s in sec){
          s.block();
      }
    }
  }
}