import 'package:chess_new/models/board_manager.dart';
import 'package:chess_new/models/piece_placement.dart';
import 'package:chess_new/widgets/board_widget.dart';
import 'package:flutter/material.dart';

class GameWidget extends StatefulWidget {
  const GameWidget({super.key});

  @override
  State<GameWidget> createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {
  final textEditingController = TextEditingController();

  var boardWidgetKeyValue =
      false; // This is a dummy value. It doesn't matter what it is. It's just to force the BoardWidget to reinitialize.

  var boardManager = BoardManager();

  var isWhiteToMove = true;
  var isWhitePerspective = true;

  // TODO: Optimize the dragging feature by calling setState only when and only where it's needed. We don't need to rebuild the whole GridView, if the change only affect a single square.
  // TODO: Generalize the function names so that it can describe both tapping and dragging.

  void resetToStartingPosition() {
    setState(() {
      boardManager = BoardManager();
      isWhiteToMove = true;
      isWhitePerspective = true;
      changeBoardWidgetKey();
    });
  }

  void setFen() {
    resetToStartingPosition();
    if (textEditingController.text.isNotEmpty) {
      setState(() {
        boardManager =
            BoardManager()
              ..currentPiecePlacement = PiecePlacement.fromFenPosition(
                textEditingController.text,
              );
      });
    }
  }

  /// This changes the key value to force the BoardWidget to reinitialize.
  void changeBoardWidgetKey() {
    boardWidgetKeyValue = !boardWidgetKeyValue;
  }

  void toggleWhitePerspective() {
    setState(() {
      isWhitePerspective = !isWhitePerspective;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: "Set FEN",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: resetToStartingPosition,
                child: Text('Starting'),
              ),
              OutlinedButton(onPressed: setFen, child: Text('Set')),
            ],
          ),
        ),
        BoardWidget(
          isWhitePerspective: isWhitePerspective,
          boardManager: boardManager,
          toggleWhitePerspective: toggleWhitePerspective,
          key: ValueKey(boardWidgetKeyValue),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: OutlinedButton(
            onPressed: () {
              print('Test');
            },
            child: Text('Click me'),
          ),
        ),
      ],
    );
  }
}
