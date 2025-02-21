import 'package:chess_new/models/board_manager.dart';
import 'package:chess_new/models/move.dart';
import 'package:chess_new/models/square.dart';
import 'package:chess_new/widgets/square_widget.dart';
import 'package:flutter/material.dart';

class BoardWidget extends StatelessWidget {
  final bool isWhitePerspective;
  final BoardManager boardManager;
  final Square? selectedSquare;
  final List<Square> dottedSquares;
  final Move? lastMove;
  final void Function(Square) onTapSquare;

  const BoardWidget({
    super.key,
    required this.isWhitePerspective,
    required this.boardManager,
    required this.selectedSquare,
    required this.dottedSquares,
    required this.lastMove,
    required this.onTapSquare,
  });

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
        final piece = boardManager.currentPiecePlacement.pieceAt(square);

        final isAttacked = boardManager
            .attackedSquares(isWhitePerspective)
            .contains(square);
        final isSelected = square == selectedSquare;
        final doesBelongToLastMove =
            square == lastMove?.from || square == lastMove?.to;

        final Color? highlightColor;
        if (isSelected || doesBelongToLastMove) {
          highlightColor = Color(0x88fff35f);
        } else if (isAttacked) {
          highlightColor = null; // Color(0x44AA0000);
        } else {
          highlightColor = null;
        }

        return SquareWidget(
          square,
          piece: piece,
          highlightColor: highlightColor,
          isDotted: dottedSquares.contains(square),
          onTapSquare: onTapSquare,
        );
      },
    );
  }
}
