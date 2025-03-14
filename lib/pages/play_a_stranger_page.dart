import 'package:flutter/material.dart';

class PlayAStrangerPage extends StatelessWidget {
  static const route = '/play_a_stranger';

  const PlayAStrangerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Play a Stranger')),
      body: Center(child: Text('Play a Stranger')),
    );
  }
}
