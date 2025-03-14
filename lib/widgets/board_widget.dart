import 'package:chess_new/models/board_manager.dart';
import 'package:chess_new/models/move.dart';
import 'package:chess_new/models/square.dart';
import 'package:chess_new/widgets/square_widget.dart';
import 'package:flutter/material.dart';

class BoardWidget extends StatefulWidget {
  final bool isWhitePerspective;
  final BoardManager boardManager;
  final void Function() toggleWhitePerspective;

  const BoardWidget({
    super.key,
    required this.isWhitePerspective,
    required this.boardManager,
    required this.toggleWhitePerspective,
  });

  @override
  State<BoardWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  Square? selectedSquare;

  var isBeingDragged = false;

  Move? lastMove;
  var legalMoveSquares = <Square>[];

  @override
  void initState() {
    print('BoardWidget initState');
    super.initState();
  }

  void setIsBeingDragged(bool isBeingDragged) {
    // TODO: Should I wrap this with setState?
    this.isBeingDragged = isBeingDragged;
  }

  void onTapSquare(Square tappedSquare) {
    if (selectedSquare == null) {
      if (isSelfPiece(tappedSquare)) {
        // Selects after verifying tapped square has a piece of the color to move
        setState(() {
          selectSquare(tappedSquare);
        });
      }
    } else {
      if (tappedSquare == selectedSquare) {
        setState(() {
          unselectSquare();
        });
      } else if (isSelfPiece(tappedSquare)) {
        // Self pieces never get highligted
        setState(() {
          selectSquare(tappedSquare);
        });
      } else if (legalMoveSquares.contains(tappedSquare)) {
        // If there are highlighted squares, a square must be in the selected state. So selectedSquare will not be null.
        // No need to setState here, because widget.toggleWhitePerspective will call setState in the GameWidget.
        widget.boardManager.movePiece(Move(selectedSquare!, tappedSquare));
        lastMove = widget.boardManager.lastMove;
        unselectSquare();
        widget.toggleWhitePerspective();
      } else {
        // Not highligted non-self squares
        setState(() {
          unselectSquare();
        });
      }
    }
  }

  void selectSquare(Square square) {
    selectedSquare = square;
    legalMoveSquares = widget.boardManager.legalMoves(square);
  }

  void unselectSquare() {
    selectedSquare = null;
    legalMoveSquares = [];
  }

  bool isSelfPiece(Square square) {
    final piece = widget.boardManager.currentPiecePlacement.pieceAt(square);
    return piece != null && piece.isWhite == widget.isWhitePerspective;
  }

  // TODO: Solve the dragging multiple pieces simultaneously problem.
  // TODO: Add a circle on top of the square on which a piece is being dragged on.

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
        final id = widget.isWhitePerspective ? i : 63 - i;
        final square = Square.fromId(id);
        final piece = widget.boardManager.currentPiecePlacement.pieceAt(square);

        final isAttacked = widget.boardManager
            .attackedSquares(widget.isWhitePerspective)
            .contains(square);
        final isSelected = square == selectedSquare;
        final doesBelongToLastMove =
            square == lastMove?.from || square == lastMove?.to;

        final isOccupiedByEnemyPiece = widget.boardManager
            .isOccupiedByEnemyPiece(square, widget.isWhitePerspective);

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
