import 'package:flutter/material.dart';

class PlayLocalPage extends StatelessWidget {
  static const route = '/play_local';

  const PlayLocalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Play Local')),
      body: Center(child: Text('Play Local')),
    );
  }
}
