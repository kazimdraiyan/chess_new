import 'package:chess_new/constants.dart';
import 'package:chess_new/models/piece.dart';
import 'package:chess_new/models/square.dart';
import 'package:chess_new/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SquareWidget extends StatelessWidget {
  final Square square;
  final Piece? piece;
  final Color? highlightColor;
  final bool isDotted;
  final void Function(Square square) onTapSquare;

  const SquareWidget(
    this.square, {
    this.piece,
    this.highlightColor,
    this.isDotted = false,
    required this.onTapSquare,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapSquare(square),
      child: Container(
        color:
            square.isDark
                ? Color(Constants.darkSquareColor)
                : Color(Constants.lightSquareColor),
        child: Container(
          color: highlightColor,
          child: Center(
            child: Stack(
              children: [
                if (piece != null)
                  Opacity(
                    opacity: 0.5,
                    child: SvgPicture.asset(
                      Utils.iconSrcOf(
                        piece!.pieceType,
                        isWhite: piece!.isWhite,
                      ), // TODO: Why ! needed?
                    ),
                  ),
                if (isDotted)
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(
                          100,
                          50,
                          50,
                          50,
                        ), // TODO: Take this into Constants
                      ),
                      width: 18,
                      height: 18,
                    ),
                  ),
                Center(child: Text(square.algebraicNotation)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
