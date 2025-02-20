import 'package:chess_new/models/piece.dart';
import 'package:chess_new/models/square.dart';
import 'package:chess_new/utils.dart';

class PiecePlacement {
  late final List<List<Piece?>>
  pieceMatrix; // rank 1 (file 1-8), rank 2 (file 1-8), ...

  PiecePlacement.fromPieceMatrix(this.pieceMatrix);

  PiecePlacement.fromFenPosition(String fenPosition) {
    pieceMatrix = [];

    final fenRanks = fenPosition.split('/').reversed;
    for (final fenRank in fenRanks) {
      List<Piece?> rank = [];
      final fenRankLetters = fenRank.split('');
      for (final fenRankLetter in fenRankLetters) {
        final emptySquareCount = int.tryParse(fenRankLetter);
        if (emptySquareCount == null) {
          final pieceType = Utils.pieceTypeNamed[fenRankLetter.toLowerCase()]!;
          final isWhite = fenRankLetter.toUpperCase() == fenRankLetter;
          rank.add(Piece(pieceType: pieceType, isWhite: isWhite));
        } else {
          for (var i = 0; i < emptySquareCount; i++) {
            rank.add(null);
          }
        }
      }
      pieceMatrix.add(rank);
    }
    print(pieceMatrix);
  }

  factory PiecePlacement.starting() {
    return PiecePlacement.fromFenPosition(
      'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR',
    );
  }

  PiecePlacement movePiece(Square fromSquare, Square toSquare) {
    final pieceMatrixCopy = [
      for (final rank in pieceMatrix) [...rank],
    ];
    final piece = pieceAt(fromSquare);
    if (piece == null) {
      return this; // If the fromSquare contains no piece, it returns the original PiecePlacement
    }
    pieceMatrixCopy[fromSquare.rank - 1][fromSquare.file - 1] = null;
    pieceMatrixCopy[toSquare.rank - 1][toSquare.file - 1] = piece;
    return PiecePlacement.fromPieceMatrix(pieceMatrixCopy);
  }

  String get fenPosition {
    var result = '';
    for (final rank in pieceMatrix.reversed) {
      var emptySquareCount = 0;

      for (final piece in rank) {
        if (piece != null) {
          if (emptySquareCount != 0) result += emptySquareCount.toString();
          final fenInitial = Utils.fenInitialOf[piece.pieceType]!;
          final fenInitialWithCase =
              piece.isWhite ? fenInitial.toUpperCase() : fenInitial;
          result += fenInitialWithCase;
          emptySquareCount = 0;
        } else {
          emptySquareCount += 1;
        }
      }
      if (rank.last == null) {
        result += emptySquareCount.toString();
        emptySquareCount = 0;
      }
      result += '/';
    }

    return result.substring(
      0,
      result.length - 1,
    ); // removes the trailing '/' in the String
  }

  Piece? pieceAt(Square square) {
    final piece = pieceMatrix[square.rank - 1][square.file - 1];
    return piece;
  }

  bool isEmpty(Square square) {
    return pieceAt(square) == null;
  }

  bool isOccupiedByWhite(Square square) {
    return !isEmpty(square) && pieceAt(square)!.isWhite;
  }

  bool isOccupiedByBlack(Square square) {
    return !isEmpty(square) && !pieceAt(square)!.isWhite;
  }
}
