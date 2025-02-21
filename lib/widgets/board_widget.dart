import 'package:chess_new/models/board_manager.dart';
import 'package:chess_new/models/move.dart';
import 'package:chess_new/models/square.dart';
import 'package:chess_new/widgets/square_widget.dart';
import 'package:flutter/material.dart';

class BoardWidget extends StatelessWidget {
  final bool isWhitePerspective;
  final bool isBeingDragged;
  final BoardManager boardManager;
  final Square? selectedSquare;
  // final Square? draggedOnSquare;
  final List<Square> legalMoveSquares;
  final Move? lastMove;
  final void Function(Square) onTapSquare;
  final void Function(bool) setIsBeingDragged;
  // final void Function(Square?) setDraggedOnSquare;

  const BoardWidget({
    super.key,
    required this.isWhitePerspective,
    required this.isBeingDragged,
    required this.boardManager,
    required this.selectedSquare,
    // required this.draggedOnSquare,
    required this.legalMoveSquares,
    required this.lastMove,
    required this.onTapSquare,
    required this.setIsBeingDragged,
    // required this.setDraggedOnSquare,
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

        final isDraggable =
            !isBeingDragged && !isOccupiedByEnemyPiece && piece != null;

        return Stack(
          children: [
            DragTarget<Square>(
              onWillAcceptWithDetails: (_) {
                return legalMoveSquares.contains(square);
              },
              onAcceptWithDetails: (_) {
                onTapSquare(square);
              },
              builder:
                  (context, _, __) => Draggable<Square>(
                    data: square,
                    maxSimultaneousDrags: isDraggable ? 1 : 0,
                    onDragStarted: () {
                      setIsBeingDragged(true);
                      onTapSquare(square);
                    },
                    onDragEnd: (_) {
                      setIsBeingDragged(false);
                    },
                    onDraggableCanceled: (_, __) => onTapSquare(square),
                    feedback: SizedBox(
                      width: 80,
                      height: 80,
                      child: PieceIconWidget(piece: piece),
                    ),
                    childWhenDragging: SquareWidget(
                      square,
                      highlightColor: highlightColor,
                      onTapSquare: onTapSquare,
                    ),
                    child: SquareWidget(
                      square,
                      piece: piece,
                      highlightColor: highlightColor,
                      isDotted:
                          legalMoveSquares.contains(square) && piece == null,
                      isCircled:
                          legalMoveSquares.contains(square) &&
                          isOccupiedByEnemyPiece,
                      onTapSquare: onTapSquare,
                    ),
                  ),
            ),
            // if (square == draggedOnSquare)
            //   Center(
            //     child: OverflowBox(
            //       maxWidth: 85,
            //       maxHeight: 85,
            //       child: Container(
            //         decoration: BoxDecoration(
            //           color: Colors.red.withAlpha(100),
            //           shape: BoxShape.circle,
            //         ),
            //       ),
            //     ),
            //   ),
          ],
        );
      },
    );
  }
}
