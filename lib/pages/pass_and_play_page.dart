import 'package:chess_new/widgets/board.dart';
import 'package:flutter/material.dart';

class PassAndPlayPage extends StatelessWidget {
  const PassAndPlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shut up')),
      body: Board(),
      resizeToAvoidBottomInset: false,
    );
  }
}
