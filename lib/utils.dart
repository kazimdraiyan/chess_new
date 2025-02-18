import 'package:chess_new/models/piece.dart';

class Utils {
  static const fenInitial = {
    PieceType.king: "k",
    PieceType.queen: "q",
    PieceType.rook: "r",
    PieceType.bishop: "b",
    PieceType.knight: "n",
    PieceType.pawn: "p",
  };

  static String iconSrcOf(PieceType pieceType, {bool isWhite = true}) {
    return 'assets/pieces_icon/${fenInitial[pieceType]!}${isWhite ? 'l' : 'd'}.svg';
  }
}