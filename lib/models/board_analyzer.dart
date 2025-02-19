import 'package:chess_new/models/piece.dart';
import 'package:chess_new/models/piece_placement.dart';
import 'package:chess_new/models/square.dart';

class BoardAnalyzer {
  final PiecePlacement _piecePlacement;

  const BoardAnalyzer(this._piecePlacement);

  List<Square> legalMoves(Square square) {
    final piece = _piecePlacement.pieceAt(square);
    if (piece == null) {
      return [];
    } else if (piece.pieceType == PieceType.rook) {
      return _rookLegalMoves(square); // TODO: Also check if it's pinned or not
    } else if (piece.pieceType == PieceType.bishop) {
      return _bishopLegalMoves(square); // TODO: Implement other piece moves
    } else {
      return [];
    }
  }

  List<Square> _rookLegalMoves(Square square) {
    final piece = _piecePlacement.pieceAt(square);

    final orthogonalSquares = square.orthogonalSquares;
    print(orthogonalSquares);

    return traverseTillBlockage(orthogonalSquares, piece!.isWhite);
  }

  List<Square> _bishopLegalMoves(Square square) {
    final piece = _piecePlacement.pieceAt(square);

    final diagonalSquares = square.diagonalSquares;
    print(diagonalSquares);

    return traverseTillBlockage(diagonalSquares, piece!.isWhite);
  }

  List<Square> traverseTillBlockage(
    List<List<Square>> directionalSquares,
    bool isOriginalPieceWhite,
  ) {
    final result = <Square>[];

    for (final singleDirectionSquares in directionalSquares) {
      for (final testingSquare in singleDirectionSquares) {
        if (_piecePlacement.isEmpty(testingSquare)) {
          result.add(testingSquare);
        } else {
          if ((_piecePlacement.isOccupiedByWhite(testingSquare) &&
                  isOriginalPieceWhite) ||
              (_piecePlacement.isOccupiedByBlack(testingSquare) &&
                  !isOriginalPieceWhite)) {
            break; // Blocked by a friendly piece, so continue to traverse on the next direction
          } else {
            result.add(testingSquare);
            break; // Blocked by a enemy piece, so include the square and continue to traverse on the next direction
          }
        }
      }
    }
    return result;
  }
}
