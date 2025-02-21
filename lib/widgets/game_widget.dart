import 'package:chess_new/models/board_manager.dart';
import 'package:chess_new/models/move.dart';
import 'package:chess_new/models/piece_placement.dart';
import 'package:chess_new/models/square.dart';
import 'package:chess_new/widgets/board_widget.dart';
import 'package:flutter/material.dart';

class GameWidget extends StatefulWidget {
  const GameWidget({super.key});

  @override
  State<GameWidget> createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {
  final textEditingController = TextEditingController();

  var boardManager = BoardManager();
  Move? lastMove;

  var isWhiteToMove = true;
  var isWhitePerspective = true;
  Square? selectedSquare;

  var legalMoveSquares = <Square>[];

  void onTapSquare(Square tappedSquare) {
    if (selectedSquare == null) {
      if (isSelfPiece(tappedSquare)) {
        // Selects after verifying tapped square has a piece of the color to move
        setState(() {
          selectSquare(tappedSquare);
        });
      }
    } else {
      setState(() {
        if (tappedSquare == selectedSquare) {
          unselectSquare();
        } else if (isSelfPiece(tappedSquare)) {
          // Self pieces never get highligted
          selectSquare(tappedSquare);
        } else if (legalMoveSquares.contains(tappedSquare)) {
          // If there are highlighted squares, a square must be in the selected state. So selectedSquare will not be null.
          boardManager.movePiece(Move(selectedSquare!, tappedSquare));
          lastMove = boardManager.lastMove;
          isWhitePerspective = !isWhitePerspective;
          unselectSquare();
        } else {
          // Not highligted non-self squares
          unselectSquare();
        }
      });
    }
  }

  void selectSquare(Square square) {
    selectedSquare = square;
    legalMoveSquares = boardManager.legalMoves(square);
  }

  void unselectSquare() {
    setState(() {
      selectedSquare = null;
      legalMoveSquares = [];
    });
  }

  bool isSelfPiece(Square square) {
    final piece = boardManager.currentPiecePlacement.pieceAt(square);
    return piece != null && piece.isWhite == isWhitePerspective;
  }

  void resetToStartingPosition() {
    setState(() {
      boardManager = BoardManager();
      lastMove = null;
      isWhiteToMove = true;
      isWhitePerspective = true;
      selectedSquare = null;
      legalMoveSquares = [];
    });
  }

  void setFen() {
    resetToStartingPosition();
    if (textEditingController.text.isNotEmpty) {
      setState(() {
        boardManager =
            BoardManager()
              ..currentPiecePlacement = PiecePlacement.fromFenPosition(
                textEditingController.text,
              );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: "Set FEN",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: resetToStartingPosition,
                child: Text('Starting'),
              ),
              OutlinedButton(onPressed: setFen, child: Text('Set')),
            ],
          ),
        ),
        BoardWidget(
          isWhitePerspective: isWhitePerspective,
          boardManager: boardManager,
          selectedSquare: selectedSquare,
          lastMove: lastMove,
          legalMoveSquares: legalMoveSquares,
          onTapSquare: onTapSquare,
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: OutlinedButton(
            onPressed: () {
              // Testing
            },
            child: Text('Click me'),
          ),
        ),
      ],
    );
  }
}
