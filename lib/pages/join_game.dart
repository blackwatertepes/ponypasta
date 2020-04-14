import 'package:flutter/material.dart';

import '../components/game.dart';

class JoinGamePage extends StatelessWidget {
  final String title;
  final String roomId;

  JoinGamePage({Key key, this.title, this.roomId}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("${this.title} | ${this.roomId}")),
      ),
      body: GameWidget(
        title: this.title,
        roomId: this.roomId,
        isPlayer: 'blue'
      )
    );
  }
}