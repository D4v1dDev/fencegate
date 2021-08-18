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

  late bool _canRotate=false;
  late Image imagen;
  
  Section.fromJSON(Map line, this.board) {
    _correctDirection = line ["cDirection"];
    _type = line ["type"];
    
    shuffle();
    imagen=chooseImage();
    _canRotate=true;
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
    imagen=chooseImage();
  }

  void shuffle(){
    do{
      _direction = Random().nextInt(3);
    }while(_direction==_correctDirection);
  }
  
  Image chooseImage(){
    switch(_type){
      case TYPE_PIECE_CORNER:
        return Image.asset("$RUTA$_type$_direction.png",fit: BoxFit.cover);
      case TYPE_PIECE_DOUBLE_CORNER:
      case TYPE_PIECE_RECT:
        return Image.asset("$RUTA$_type${_direction%2}.png",fit: BoxFit.cover);
      default:
        return (Image.asset("${RUTA}2.png",fit: BoxFit.cover,));
    }
  }
  
  Widget getWidget() {
    return SizedBox(
      child: AnimatedSection(this),
      width: board.pieceSize,
      height: board.pieceSize,
    );
  }

  void block() {
    _canRotate = false;
  }
}

class AnimatedSection extends StatefulWidget {
  const AnimatedSection(this._s,{Key? key}) : super(key: key);

  final Section _s;
  
  @override
  State<AnimatedSection> createState() => _AnimatedSectionState(_s);
}

class _AnimatedSectionState extends State<AnimatedSection>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    lowerBound: 0,
    upperBound: 0.25,
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );

  final Section _s;

  _AnimatedSectionState(this._s);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: IconButton(
          onPressed: () {
            if (!_s._canRotate) return;
            _s._canRotate = false;
            _controller.forward(from: 0).whenComplete(() {
                _s._canRotate = true;
                setState(() {
                    _s.rotate();
                    _controller.value=0;
                });
                _s.board.build();
                if (_s.board.isCorrect()) {
                  _s.board.win();
                }
            });
          },
          padding: EdgeInsets.zero,
          icon: _s.imagen),
    );
  }
}