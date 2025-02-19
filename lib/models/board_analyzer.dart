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
      return _bishopLegalMoves(square);
    } else if (piece.pieceType == PieceType.queen) {
      return _queenLegalMoves(square);
    } else if (piece.pieceType == PieceType.knight) {
      return _knightLegalMoves(square);
    } else {
      // TODO: Implement other piece moves
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

  List<Square> _queenLegalMoves(Square square) {
    final piece = _piecePlacement.pieceAt(square);

    final orthogonalSquares = square.orthogonalSquares;
    final diagonalSquares = square.diagonalSquares;
    final allDirectionalSquares = [...orthogonalSquares, ...diagonalSquares];
    print(allDirectionalSquares);

    return traverseTillBlockage(allDirectionalSquares, piece!.isWhite);
  }

  List<Square> _knightLegalMoves(Square square) {
    final piece = _piecePlacement.pieceAt(square)!;
    final result = <Square>[];

    final knightSquares = <Square>[];
    for (var fileStep = -2; fileStep <= 2; fileStep++) {
      if (fileStep == 0) continue;
      for (var rankStep = -2; rankStep <= 2; rankStep++) {
        if (rankStep == 0 || fileStep.abs() == rankStep.abs()) continue;

        final testingFile = square.file + fileStep;
        final testingRank = square.rank + rankStep;
        if (1 <= testingFile &&
            testingFile <= 8 &&
            1 <= testingRank &&
            testingRank <= 8) {
          knightSquares.add(Square(testingFile, testingRank));
        }
      }
    }

    // Filters blockage by friendly pieces
    for (final testingSquare in knightSquares) {
      if (!isOccupiedByFriendlyPiece(testingSquare, piece.isWhite)) {
        result.add(testingSquare);
      }
    }

    return result;
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
          if (isOccupiedByFriendlyPiece(testingSquare, isOriginalPieceWhite)) {
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

  bool isOccupiedByFriendlyPiece(
    Square testingSquare,
    bool isOriginalPieceWhite,
  ) {
    return (_piecePlacement.isOccupiedByWhite(testingSquare) &&
            isOriginalPieceWhite) ||
        (_piecePlacement.isOccupiedByBlack(testingSquare) &&
            !isOriginalPieceWhite);
  }
}
