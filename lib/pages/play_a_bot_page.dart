import 'package:flutter/material.dart';

class PlayABotPage extends StatelessWidget {
  static const route = '/play_a_bot';

  const PlayABotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Play a Bot')),
      body: Center(child: Text('Play a Bot')),
    );
  }
}
