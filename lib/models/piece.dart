import 'package:chess_new/models/square.dart';

enum PieceType { king, queen, rook, bishop, knight, pawn }

const promotionOptions = [PieceType.queen, PieceType.rook, PieceType.bishop, PieceType.knight];

class Piece {
  final bool _isWhite;

  PieceType _pieceType;
  Square square;

  Piece({required PieceType pieceType, required this.square, bool isWhite = true})
    : _pieceType = pieceType,
      _isWhite = isWhite;
  
  bool get isWhite => _isWhite;
  PieceType get pieceType => _pieceType;

  void promoteTo(PieceType targetPieceType) {
    if (_pieceType == PieceType.pawn && promotionOptions.contains(targetPieceType)) {
      _pieceType = targetPieceType;
    } else {
      print("Invalid promotion");
    }
  }
}
