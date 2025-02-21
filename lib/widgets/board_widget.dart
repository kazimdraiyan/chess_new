import 'package:chess_new/models/board_manager.dart';
import 'package:chess_new/models/move.dart';
import 'package:chess_new/models/square.dart';
import 'package:chess_new/widgets/square_widget.dart';
import 'package:flutter/material.dart';

class BoardWidget extends StatelessWidget {
  final bool isWhitePerspective;
  final BoardManager boardManager;
  final Square? selectedSquare;
  final List<Square> legalMoveSquares;
  final Move? lastMove;
  final void Function(Square) onTapSquare;

  const BoardWidget({
    super.key,
    required this.isWhitePerspective,
    required this.boardManager,
    required this.selectedSquare,
    required this.legalMoveSquares,
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

        final isOccupiedByEnemyPiece = boardManager.isOccupiedByEnemyPiece(
          square,
          isWhitePerspective,
        );

        final Color? highlightColor;
        if (isSelected || doesBelongToLastMove) {
          highlightColor = Colors.yellow.withAlpha(100);
        } else if (isAttacked) {
          // TODO: Remove this
          highlightColor = null; // Colors.red.withAlpha(150);
        } else {
          highlightColor = null;
        }

        return SquareWidget(
          square,
          piece: piece,
          highlightColor: highlightColor,
          isDotted: legalMoveSquares.contains(square) && piece == null,
          isCircled:
              legalMoveSquares.contains(square) && isOccupiedByEnemyPiece,
          onTapSquare: onTapSquare,
        );
      },
    );
  }
}
