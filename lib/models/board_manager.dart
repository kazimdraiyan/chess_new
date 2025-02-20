import 'package:chess_new/models/board_analyzer.dart';
import 'package:chess_new/models/piece_placement.dart';
import 'package:chess_new/models/square.dart';

class BoardManager {
  var currentPiecePlacement = PiecePlacement.starting();

  List<Square> legalMoves(Square square) {
    final boardAnalyzer = BoardAnalyzer(currentPiecePlacement);
    return boardAnalyzer.legalMoves(square);
  }

  void movePiece(Square fromSquare, Square toSquare) {
    currentPiecePlacement = currentPiecePlacement.movePiece(
      fromSquare,
      toSquare,
    );
  }
}
