import 'package:chess_new/models/piece.dart';
import 'package:chess_new/models/square.dart';
import 'package:chess_new/utils.dart';

class Move {
  final Square from;
  final Square to;
  final Piece piece;
  final bool causesCheck;
  final bool capturesPiece;

  const Move(
    this.from,
    this.to, {
    required this.piece,
    this.causesCheck = false,
    this.capturesPiece = false,
  });

  // TODO: Implement correct algebraic notation
  String get algebraicNotation {
    var result = '';

    if (piece.pieceType != PieceType.pawn) {
      result += Utils.fenInitialOf[piece.pieceType]!.toUpperCase();
    }
    if (capturesPiece) {
      result += 'x';
      if (piece.pieceType == PieceType.pawn) {
        result = from.algebraicNotation[0] + result;
      }
    }
    result += to.algebraicNotation;
    if (causesCheck) {
      result += '+';
    }

    // TODO: Implement castling, promotion, en passant, checkmate, draw, disambiguating moves, etc.

    return result;
  }

  @override
  String toString() => algebraicNotation;
}
