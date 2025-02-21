import 'package:chess_new/models/board_analyzer.dart';
import 'package:chess_new/models/piece_placement.dart';
import 'package:chess_new/models/square.dart';

class BoardManager {
  var currentPiecePlacement = PiecePlacement.starting();

  List<Square> legalMoves(Square square) {
    return BoardAnalyzer(currentPiecePlacement).legalMoves(square);
  }

  List<Square> attackedSquares(bool isWhitePerspective) {
    return BoardAnalyzer(
      currentPiecePlacement,
    ).attackedSquares(isWhitePerspective);
  }

  void movePiece(Square fromSquare, Square toSquare) {
    currentPiecePlacement = currentPiecePlacement.movePiece(
      fromSquare,
      toSquare,
    );
    // TODO: Save captured pieces and calculater advantage
    // TODO: Preserve move history
  }
}
