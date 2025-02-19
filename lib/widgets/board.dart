import 'package:chess_new/constants.dart';
import 'package:chess_new/models/board_manager.dart';
import 'package:chess_new/models/square.dart';
import 'package:chess_new/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final boardManager = BoardManager();

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
        final piece =
            boardManager.currentPiecePlacement.pieceMatrix.reversed
                .toList()[square.rank - 1][square.file -
                1]; // Needed to reverse the pieceMatrix because GridView is reversed, i.e., it renders the grid from bottom to top, left to right.

        return Container(
          color:
              square.isDark
                  ? Color(Constants.darkSquareColor)
                  : Color(Constants.lightSquareColor),
          child: Center(
            child: Stack(
              children: [
                if (piece != null)
                  Opacity(
                    opacity: 0.5,
                    child: SvgPicture.asset(
                      Utils.iconSrcOf(piece.pieceType, isWhite: piece.isWhite),
                    ),
                  ),
                Center(child: Text(square.algebraicNotation)),
              ],
            ),
          ),
        );
      },
    );
  }
}
