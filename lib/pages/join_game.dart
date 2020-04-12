import 'package:flutter/material.dart';

import '../components/game.dart';

class JoinGamePage extends StatefulWidget {
  JoinGamePage({Key key, this.title, this.roomId}) : super(key: key);

  final String title;
  final String roomId;

  @override
  _JoinGamePageState createState() => _JoinGamePageState();
}

class _JoinGamePageState extends State<JoinGamePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("${widget.title} | ${widget.roomId}")),
      ),
      body: GamePage(
        title: widget.title,
        roomId: widget.roomId,
        isPlayer: 'blue'
      )
    );
  }
}