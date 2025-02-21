import 'package:chess_new/models/square.dart';

class Move {
  final Square from;
  final Square to;
  final bool causesCheck;

  const Move(this.from, this.to, {this.causesCheck = false});
}
