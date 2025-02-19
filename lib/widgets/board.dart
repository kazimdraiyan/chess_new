import 'package:chess_new/constants.dart';
import 'package:chess_new/models/board_manager.dart';
import 'package:chess_new/models/piece_placement.dart';
import 'package:chess_new/models/square.dart';
import 'package:chess_new/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Board extends StatefulWidget {
  final String? fen;

  const Board({this.fen, super.key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final boardManager = BoardManager();

  var isWhiteToMove = true;
  var isWhitePerspective = true;

  var highlightedSquares = <Square>[];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: "SET Fen",
              border: OutlineInputBorder(),
            ),

            onSubmitted: (value) {
              setState(() {
                boardManager.currentPiecePlacement =
                    PiecePlacement.fromFenPosition(value);
              });
            },
          ),
        ),
        GridView.builder(
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
            final piece = boardManager.currentPiecePlacement.pieceAt(square);

            return GestureDetector(
              onTap: () {
                // print(boardManager.currentPiecePlacement.pieceAt(square));
                setState(() {
                  highlightedSquares = boardManager.legalMoves(square);
                });
              },
              child: Container(
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
                            Utils.iconSrcOf(
                              piece.pieceType,
                              isWhite: piece.isWhite,
                            ),
                          ),
                        ),
                      if (highlightedSquares.contains(square))
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(
                                100,
                                255,
                                50,
                                50,
                              ), // TODO: Take this into Constants
                            ),
                            width: 18,
                            height: 18,
                          ),
                        ),
                      Center(child: Text(square.algebraicNotation)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
