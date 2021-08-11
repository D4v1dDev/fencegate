import 'dart:math';

import 'package:flutter/material.dart';

import 'Board.dart';

class Section {

  static const String RUTA = "res/icons/pieces/piece";

  //TO ADD A NEW TYPE JUST WRITE IT BELOW AND ADD IT INTO isCorrectlyPlaced & getWidget methods
  static const int TYPE_PIECE_CORNER = 0;
  static const int TYPE_PIECE_DOUBLE_CORNER = 1;
  static const int TYPE_PIECE_RECT = 3;
  static const int TYPE_PIECE_BLANK = 2;

  late final int _correctDirection, _type;
  int _direction = 0;

  final Board board;

  bool canRotate=true;

  Section.fromJSON(Map line, this.board) {
    _correctDirection = line ["cDirection"];
    _type = line ["type"];

    shuffle();
  }

  bool isCorrectlyPlaced(){
    switch(_type){
      case TYPE_PIECE_CORNER:
        return _direction==_correctDirection;
      case TYPE_PIECE_DOUBLE_CORNER:
      case TYPE_PIECE_RECT:
        return _direction%2==_correctDirection%2;
      default:
        return true;
    }
  }

  void rotate(){
    _direction+=1;
    _direction%=4;
  }

  void shuffle(){
    do{
      _direction = Random().nextInt(3);
    }while(_direction==_correctDirection);
  }

  Widget getWidget() {
    Image imagen;
    switch(_type){
      case TYPE_PIECE_CORNER:
        imagen = Image.asset("$RUTA$_type$_direction.png",fit: BoxFit.cover);
        break;
      case TYPE_PIECE_DOUBLE_CORNER:
      case TYPE_PIECE_RECT:
        imagen = Image.asset("$RUTA$_type${_direction%2}.png",fit: BoxFit.cover);
        break;
      default:
        imagen = (Image.asset("${RUTA}2.png",fit: BoxFit.cover,));
    }

    return SizedBox(
      child:IconButton(
        onPressed: () {
            if(!canRotate) return;
            rotate();
            board.build();
            if(board.isCorrect()){
              board.win();
            }
          },
          padding: EdgeInsets.zero,
          icon: imagen),
      width: board.pieceSize,
      height: board.pieceSize,
    );
  }

  void block() {
    canRotate = false;
  }
}