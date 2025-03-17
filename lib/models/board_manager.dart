import 'package:chess_new/models/board_analyzer.dart';
import 'package:chess_new/models/move.dart';
import 'package:chess_new/models/piece_placement.dart';
import 'package:chess_new/models/square.dart';

class BoardManager {
  var currentPiecePlacement = PiecePlacement.starting();
  final moveHistory = <Move>[];

  List<Square> legalMoves(Square square) {
    return BoardAnalyzer(currentPiecePlacement).legalMoves(square);
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
    // TODO: Remove duplicate by extracting some piece of code to a method
    final piece = currentPiecePlacement.pieceAt(from)!;

    final testingPiecePlacement = currentPiecePlacement.movePiece(
      Move(from, to, piece: piece),
    );
    final testingBoardAnalyzer = BoardAnalyzer(testingPiecePlacement);

    final move = Move(
      from,
      to,
      piece: piece,
      capturesPiece: currentPiecePlacement.pieceAt(to) != null,
      causesCheck: testingBoardAnalyzer
          .attackedSquares(!piece.isWhite)
          .contains(testingPiecePlacement.kingSquare(!piece.isWhite)),
    );
    final piecePlacementAfterMoving = currentPiecePlacement.movePiece(move);
    if (piecePlacementAfterMoving != currentPiecePlacement) {
      currentPiecePlacement = piecePlacementAfterMoving;
      moveHistory.add(move);
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
