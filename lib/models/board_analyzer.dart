import 'package:chess_new/models/piece.dart';
import 'package:chess_new/models/piece_placement.dart';
import 'package:chess_new/models/square.dart';

class BoardAnalyzer {
  final PiecePlacement _piecePlacement;

  const BoardAnalyzer(this._piecePlacement);

  List<Square> attackedPieces(bool isWhitePerspective) {
    return [];
  }

  List<Square> legalMoves(Square square) {
    final filteredMoves = this.filteredMoves(square);
    // for (final filteredMove in filteredMoves) {}
    return filteredMoves;
  }

  /// filteredMoves doesn't account for pinned pieces, so some moves might leave the king in check.
  List<Square> filteredMoves(Square square) {
    final piece = _piecePlacement.pieceAt(square);
    if (piece == null) {
      return [];
    } else if (piece.pieceType == PieceType.rook) {
      return _rookfilteredMoves(square);
    } else if (piece.pieceType == PieceType.bishop) {
      return _bishopfilteredMoves(square);
    } else if (piece.pieceType == PieceType.queen) {
      return _queenfilteredMoves(square);
    } else if (piece.pieceType == PieceType.knight) {
      return _knightfilteredMoves(square);
    } else if (piece.pieceType == PieceType.pawn) {
      return _pawnfilteredMoves(square);
    } else {
      // King
      return _kingfilteredMoves(square);
    }
  }

  List<Square> _rookfilteredMoves(Square square) {
    final piece = _piecePlacement.pieceAt(square);

    final orthogonalSquares = square.orthogonalSquares;
    print(orthogonalSquares);

    return traverseTillBlockage(orthogonalSquares, piece!.isWhite);
  }

  List<Square> _bishopfilteredMoves(Square square) {
    final piece = _piecePlacement.pieceAt(square);

    final diagonalSquares = square.diagonalSquares;
    print(diagonalSquares);

    return traverseTillBlockage(diagonalSquares, piece!.isWhite);
  }

  List<Square> _queenfilteredMoves(Square square) {
    final piece = _piecePlacement.pieceAt(square);

    final orthogonalSquares = square.orthogonalSquares;
    final diagonalSquares = square.diagonalSquares;
    final allDirectionalSquares = [...orthogonalSquares, ...diagonalSquares];
    print(allDirectionalSquares);

    return traverseTillBlockage(allDirectionalSquares, piece!.isWhite);
  }

  List<Square> _knightfilteredMoves(Square square) {
    final piece = _piecePlacement.pieceAt(square)!;
    final knightSquares = square.knightSquares;

    return filterBlockageByFriendlyPieces(knightSquares, piece.isWhite);
  }

  List<Square> _kingfilteredMoves(Square square) {
    final piece = _piecePlacement.pieceAt(square)!;
    final kingSquares = square.kingSquares;

    return filterBlockageByFriendlyPieces(kingSquares, piece.isWhite);
  }

  List<Square> _pawnfilteredMoves(Square square) {
    final pawnSquares = <Square>[];
    final pawnCapturableSquares = <Square>[];

    final piece = _piecePlacement.pieceAt(square)!;

    final rankStep = piece.isWhite ? 1 : -1;

    // 1-step to the front
    pawnSquares.add(Square(square.file, square.rank + rankStep));

    // 2-step to the front if the pawn is at its starting position.
    if ((piece.isWhite && square.rank == 2) ||
        (!piece.isWhite && square.rank == 7)) {
      pawnSquares.add(Square(square.file, square.rank + rankStep * 2));
    }

    // TODO: Extract the following part to another method which returns pawnAttackSquares
    // 1-step diagonal to the front
    final testingRank = square.rank + rankStep;
    for (var fileStep = -1; fileStep <= 1; fileStep++) {
      if (fileStep == 0) continue;

      final testingFile = square.file + fileStep;
      if (testingFile < 1 || testingFile > 8) continue;

      final testingSquare = Square(testingFile, testingRank);
      print(testingSquare);
      if (isOccupiedByEnemyPiece(testingSquare, piece.isWhite)) {
        pawnCapturableSquares.add(testingSquare);
      }
    }

    return [
      ...singleDirectionTraverseTillBlockage(
        pawnSquares,
        piece.isWhite,
        isPawn: true,
      ),
      ...pawnCapturableSquares,
    ];
  }

  List<Square> filterBlockageByFriendlyPieces(
    List<Square> testingSquares,
    bool isOriginalPieceWhite,
  ) {
    final result = <Square>[];
    for (final testingSquare in testingSquares) {
      if (!isOccupiedByFriendlyPiece(testingSquare, isOriginalPieceWhite)) {
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
      result.addAll(
        singleDirectionTraverseTillBlockage(
          singleDirectionSquares,
          isOriginalPieceWhite,
        ),
      );
    }
    return result;
  }

  List<Square> singleDirectionTraverseTillBlockage(
    List<Square> singleDirectionSquares,
    bool isOriginalPieceWhite, {
    bool isPawn = false,
  }) {
    final result = <Square>[];

    for (final testingSquare in singleDirectionSquares) {
      if (_piecePlacement.isEmpty(testingSquare)) {
        result.add(testingSquare);
      } else {
        if (isOccupiedByFriendlyPiece(testingSquare, isOriginalPieceWhite)) {
          break; // Blocked by a friendly piece, so continue to traverse on the next direction
        } else {
          if (!isPawn) result.add(testingSquare);
          break; // Blocked by a enemy piece, so include the square and continue to traverse on the next direction
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

  bool isOccupiedByEnemyPiece(Square testingSquare, bool isOriginalPieceWhite) {
    return !_piecePlacement.isEmpty(testingSquare) &&
        !isOccupiedByFriendlyPiece(testingSquare, isOriginalPieceWhite);
  }
}
