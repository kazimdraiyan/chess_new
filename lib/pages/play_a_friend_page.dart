import 'package:flutter/material.dart';

class PlayAFriendPage extends StatelessWidget {
  static const route = '/play_a_friend';

  const PlayAFriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Play a Friend')),
      body: Center(child: Text('Play a Friend')),
    );
  }
}
