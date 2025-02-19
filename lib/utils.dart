import 'dart:collection';

import 'package:chess_new/models/piece.dart';

class Utils {
  static const fenInitialOf = {
    PieceType.king: "k",
    PieceType.queen: "q",
    PieceType.rook: "r",
    PieceType.bishop: "b",
    PieceType.knight: "n",
    PieceType.pawn: "p",
  };

  static final pieceTypeNamed = LinkedHashMap.fromEntries(
    fenInitialOf.entries.map((entry) => MapEntry(entry.value, entry.key)),
  ); // Inverse of fenInitialOf

  static String iconSrcOf(PieceType pieceType, {bool isWhite = true}) {
    return 'assets/pieces_icon/${fenInitialOf[pieceType]!}${isWhite ? 'l' : 'd'}.svg';
  }
}
