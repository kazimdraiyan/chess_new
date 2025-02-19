import 'package:chess_new/models/piece_placement.dart';
import 'package:chess_new/models/square.dart';

class BoardAnalyzer {
  final PiecePlacement _piecePlacement;

  const BoardAnalyzer(this._piecePlacement);

  List<Square> legalMoves(Square square) {
    final piece = _piecePlacement.pieceAt(square);
    if (piece == null) {
      return [];
    } else {
      return _rookLegalMoves(square);
    }
  }

  List<Square> _rookLegalMoves(Square square, {bool isWhite = true}) {
    final currentFile = square.file;
    final currentRank = square.rank;

    final legalSquares = <Square>[];

    for (var i = 1; i <= 8; i++) {
      if (i != currentRank) {
        legalSquares.add(Square(currentFile, i));
      }
    }
    for (var i = 1; i <= 8; i++) {
      if (i != currentFile) {
        legalSquares.add(Square(i, currentRank));
      }
    }
    return legalSquares;
  }
}
