import 'package:chess_new/models/piece.dart';
import 'package:chess_new/models/piece_placement.dart';
import 'package:chess_new/models/square.dart';

class BoardAnalyzer {
  final PiecePlacement _piecePlacement;

  const BoardAnalyzer(this._piecePlacement);

  List<Square> attackedSquares(bool isWhitePerspective) {
    final opponentPieceContainingSquares = _piecePlacement
        .certainColorPieceContainingSquares(!isWhitePerspective);

    final result = <Square>[];
    for (final opponentPieceContainingSquare
        in opponentPieceContainingSquares) {
      result.addAll(attackSquares(opponentPieceContainingSquare));
    }

    return result;
  }

  List<Square> legalMoves(Square square) {
    final piece = _piecePlacement.pieceAt(square)!;

    final filteredMoves = this.filteredMoves(square);

    print(filteredMoves);

    final result = <Square>[];
    for (final filteredMove in filteredMoves) {
      final testingBoardAnalyzer = BoardAnalyzer(
        _piecePlacement.movePiece(square, filteredMove),
      );
      final selfKingSquare = testingBoardAnalyzer._piecePlacement.kingSquare(
        piece.isWhite,
      );
      if (!testingBoardAnalyzer
          .attackedSquares(piece.isWhite)
          .contains(selfKingSquare)) {
        // King would not be in check
        result.add(filteredMove);
      }
    }
    return result;
  }

  // Attack squares should include blocking friendly pieces
  List<Square> attackSquares(Square square) {
    final piece = _piecePlacement.pieceAt(square);
    if (piece == null) {
      return [];
    } else if (piece.pieceType == PieceType.rook) {
      return _rookfilteredMoves(
        square,
        shouldIncludeBlockingFriendlyPiece: true,
      );
    } else if (piece.pieceType == PieceType.bishop) {
      return _bishopfilteredMoves(
        square,
        shouldIncludeBlockingFriendlyPiece: true,
      );
    } else if (piece.pieceType == PieceType.queen) {
      return _queenfilteredMoves(
        square,
        shouldIncludeBlockingFriendlyPiece: true,
      );
    } else if (piece.pieceType == PieceType.knight) {
      return square.knightSquares;
    } else if (piece.pieceType == PieceType.king) {
      return square.kingSquares;
    } else {
      return _pawnAttackSquares(square);
    }
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

  List<Square> _rookfilteredMoves(
    Square square, {
    shouldIncludeBlockingFriendlyPiece = false,
  }) {
    final piece = _piecePlacement.pieceAt(square);

    final orthogonalSquares = square.orthogonalSquares;

    return traverseTillBlockage(
      orthogonalSquares,
      piece!.isWhite,
      shouldIncludeBlockingFriendlyPiece: shouldIncludeBlockingFriendlyPiece,
    );
  }

  List<Square> _bishopfilteredMoves(
    Square square, {
    shouldIncludeBlockingFriendlyPiece = false,
  }) {
    final piece = _piecePlacement.pieceAt(square);

    final diagonalSquares = square.diagonalSquares;

    return traverseTillBlockage(
      diagonalSquares,
      piece!.isWhite,
      shouldIncludeBlockingFriendlyPiece: shouldIncludeBlockingFriendlyPiece,
    );
  }

  List<Square> _queenfilteredMoves(
    Square square, {
    shouldIncludeBlockingFriendlyPiece = false,
  }) {
    final piece = _piecePlacement.pieceAt(square);

    final orthogonalSquares = square.orthogonalSquares;
    final diagonalSquares = square.diagonalSquares;
    final allDirectionalSquares = [...orthogonalSquares, ...diagonalSquares];

    return traverseTillBlockage(
      allDirectionalSquares,
      piece!.isWhite,
      shouldIncludeBlockingFriendlyPiece: shouldIncludeBlockingFriendlyPiece,
    );
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

    // 1-step diagonal to the front if there's enemy pieces
    for (final testingSquare in _pawnAttackSquares(square)) {
      if (isOccupiedByEnemyPiece(testingSquare, piece.isWhite)) {
        pawnCapturableSquares.add(testingSquare);
      }
    }

    return [
      ...singleDirectionTraverseTillBlockage(
        pawnSquares,
        piece.isWhite,
        shouldIncludeBlockingEnemyPiece: false,
      ),
      ...pawnCapturableSquares,
    ];
  }

  List<Square> _pawnAttackSquares(Square square) {
    final result = <Square>[];
    final rankStep = _piecePlacement.pieceAt(square)!.isWhite ? 1 : -1;

    final testingRank = square.rank + rankStep;
    for (var fileStep = -1; fileStep <= 1; fileStep++) {
      if (fileStep == 0) continue;

      final testingFile = square.file + fileStep;
      if (testingFile < 1 || testingFile > 8) continue;

      final testingSquare = Square(testingFile, testingRank);
      result.add(testingSquare);
    }
    return result;
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
    bool isOriginalPieceWhite, {
    shouldIncludeBlockingFriendlyPiece = false,
  }) {
    final result = <Square>[];

    for (final singleDirectionSquares in directionalSquares) {
      result.addAll(
        singleDirectionTraverseTillBlockage(
          singleDirectionSquares,
          isOriginalPieceWhite,
          shouldIncludeBlockingFriendlyPiece:
              shouldIncludeBlockingFriendlyPiece,
        ),
      );
    }
    return result;
  }

  List<Square> singleDirectionTraverseTillBlockage(
    List<Square> singleDirectionSquares,
    bool isOriginalPieceWhite, {
    bool shouldIncludeBlockingFriendlyPiece = false,
    bool shouldIncludeBlockingEnemyPiece = true,
    bool isPawn = false,
  }) {
    final result = <Square>[];

    for (final testingSquare in singleDirectionSquares) {
      if (_piecePlacement.isEmpty(testingSquare)) {
        result.add(testingSquare);
      } else {
        if ((isOccupiedByFriendlyPiece(testingSquare, isOriginalPieceWhite) &&
                shouldIncludeBlockingFriendlyPiece) ||
            (isOccupiedByEnemyPiece(testingSquare, isOriginalPieceWhite) &&
                shouldIncludeBlockingEnemyPiece)) {
          result.add(testingSquare);
        }
        break;
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
