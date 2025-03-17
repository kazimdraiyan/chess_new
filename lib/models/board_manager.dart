import 'package:chess_new/models/board_analyzer.dart';
import 'package:chess_new/models/move.dart';
import 'package:chess_new/models/piece.dart';
import 'package:chess_new/models/piece_placement.dart';
import 'package:chess_new/models/square.dart';

class BoardManager {
  var currentPiecePlacement = PiecePlacement.starting();
  final moveHistory = <Move>[];

  // TODO: Give these variables more meaningful names
  var hasBothColorKingMoved = [false, false]; // [White, Black]
  var hasBothColorRooksMoved = [
    [false, false],
    [false, false],
  ]; // [White[Queen side, King side], Black[Queen side, King side]]

  List<Square> legalMoves(Square square) {
    bool? hasKingMoved;
    List<bool>? hasRooksMoved;
    if (currentPiecePlacement.pieceAt(square)!.pieceType == PieceType.king) {
      hasKingMoved =
          hasBothColorKingMoved[currentPiecePlacement.pieceAt(square)!.isWhite
              ? 0
              : 1];
      hasRooksMoved =
          hasBothColorRooksMoved[currentPiecePlacement.pieceAt(square)!.isWhite
              ? 0
              : 1];
    }
    // If the piece is not king, null will be passed to the named parameters
    return BoardAnalyzer(currentPiecePlacement).legalMoves(
      square,
      hasKingMoved: hasKingMoved,
      hasRooksMoved: hasRooksMoved,
    );
  }

  List<Square> attackedSquares(bool isWhitePerspective) {
    return BoardAnalyzer(
      currentPiecePlacement,
    ).attackedSquares(isWhitePerspective);
  }

  bool isOccupiedByEnemyPiece(Square square, bool isWhitePerspective) {
    return BoardAnalyzer(
      currentPiecePlacement,
    ).isOccupiedByEnemyPiece(square, isWhitePerspective);
  }

  void movePiece(Square from, Square to) {
    final piece = currentPiecePlacement.pieceAt(from)!;

    final piecePlacementAfterMoving = currentPiecePlacement.movePiece(
      Move(from, to, piece: piece),
    );

    final testingBoardAnalyzer = BoardAnalyzer(piecePlacementAfterMoving);

    final move = Move(
      from,
      to,
      piece: piece,
      capturesPiece: currentPiecePlacement.pieceAt(to) != null,
      causesCheck: testingBoardAnalyzer.isKingInCheck(!piece.isWhite),
    );

    if (piecePlacementAfterMoving != currentPiecePlacement) {
      // TODO: Is this if check necessary?
      currentPiecePlacement = piecePlacementAfterMoving;
      moveHistory.add(move);

      // Update castling rights
      final index = piece.isWhite ? 0 : 1;
      if (piece.pieceType == PieceType.king && !hasBothColorKingMoved[index]) {
        hasBothColorKingMoved[index] = true;
      } else if (piece.pieceType == PieceType.rook) {
        final queenSideRookInitialSquare = Square(1, piece.isWhite ? 1 : 8);
        final kingSideRookInitialSquare = Square(8, piece.isWhite ? 1 : 8);
        if (from == queenSideRookInitialSquare &&
            !hasBothColorRooksMoved[index][0]) {
          hasBothColorRooksMoved[index][0] = true;
        } else if (from == kingSideRookInitialSquare &&
            !hasBothColorRooksMoved[index][1]) {
          hasBothColorRooksMoved[index][1] = true;
        }
      }
    }
    // TODO: Save captured pieces and calculate advantage
  }

  Move? get lastMove {
    if (moveHistory.isEmpty) {
      return null;
    } else {
      return moveHistory.last;
    }
  }
}
