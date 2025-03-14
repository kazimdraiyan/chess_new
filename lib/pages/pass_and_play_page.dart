import 'package:chess_new/widgets/game_widget.dart';
import 'package:flutter/material.dart';

class PassAndPlayPage extends StatelessWidget {
  static const route = '/pass_and_play';

  const PassAndPlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pass and Play')),
      body: GameWidget(),
      resizeToAvoidBottomInset: false,
    );
  }
}
