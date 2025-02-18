import 'package:chess_new/constants.dart';
import 'package:chess_new/models/square.dart';
import 'package:flutter/material.dart';

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  var isWhiteToMove = true;
  var isWhitePerspective = true;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
      ),
      physics: NeverScrollableScrollPhysics(),
      reverse: true,
      shrinkWrap: true,
      itemCount: 64,
      itemBuilder: (context, i) {
        final id = isWhitePerspective ? i : 63 - i;
        final square = Square.fromId(id);
        return Container(
          color:
              square.isDark
                  ? Color(Constants.darkSquareColor)
                  : Color(Constants.lightSquareColor),
          child: Center(child: Text(square.algebraicNotation)),
        );
      },
    );
  }
}
