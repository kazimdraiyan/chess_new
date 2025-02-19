import 'package:chess_new/models/piece.dart';
import 'package:chess_new/models/square.dart';
import 'package:chess_new/utils.dart';

class PiecePlacement {
  final List<List<Piece?>> pieceMatrix =
      []; // rank 1 (file 1-8), rank 2 (file 1-8), ...

  PiecePlacement.fromFenPosition(String fenPosition) {
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

  // white = true means: isOccupiedByWhite, white = false means: isOccupiedByBlack
  bool isOccupiedByColor(Square square, {required bool white}) {
    if (isEmpty(square)) {
      return false;
    } else {
      if (white) {
        return pieceAt(square)!.isWhite;
      } else {
        return !pieceAt(square)!.isWhite;
      }
    }
  }
}
