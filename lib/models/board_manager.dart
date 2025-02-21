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

  void movePiece(Move move) {
    final piecePlacementAfterMoving = currentPiecePlacement.movePiece(move);
    if (piecePlacementAfterMoving != currentPiecePlacement) {
      currentPiecePlacement = piecePlacementAfterMoving;
      moveHistory.add(move);
    }
    // TODO: Save captured pieces and calculater advantage
    // TODO: Preserve move history
  }

  Move? get lastMove {
    if (moveHistory.isEmpty) {
      return null;
    } else {
      return moveHistory.last;
    }
  }
}
