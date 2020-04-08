import 'dart:convert';
import 'package:flutter/material.dart';

import '../data/words.dart';
import '../models/player.dart';

class GamePage extends StatefulWidget {
  GamePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  @override
  Widget build(BuildContext context) {
    List<String> wordList = getRandomWords(words(), 25);

    List<Player> players = [
      new Player('red', Colors.red[200], Colors.red, 9),
      new Player('blue', Colors.blue[200], Colors.blue, 8),
    ];

    // TODO: DELETE
    players[0].setScore(3);

    // const playerActions: Action[] = [
    //   { future: 'VIEW CODES', present: 'VIEWING CODES' },
    //   { future: 'HIDE CODES', present: 'GUESSING CODES' }
    // ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'End Turn',
            onPressed: () {
              // end turn
            },
          ),
        ],
      ),
      body: Column(children: <Widget>[
        Row(
          children: players.map((player) => _buildPlayerPips(context, player)).toList()
        ),
        Expanded(
          child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(0),
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
            crossAxisCount: 5,
            children:
                wordList.map((word) => _buildTile(context, word)).toList(),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: RaisedButton(
            onPressed: () {
              // End turn
            },
            child: const Text('End Turn'),
            color: Colors.red[200],
          ),
        ),
        Divider(),
        SizedBox(
          width: double.infinity,
          child: RaisedButton(
            onPressed: () {
              // Reset game
            },
            child: const Text('New Game'),
          ),
        ),
      ]),
    );
  }

  Widget _buildPlayerPips(BuildContext context, Player player) {
    return Expanded(
      child: Row(
        children: player.pips().map((filled) => _buildPlayerPip(context, player.getFillColor(), player.getBaseColor(), filled)).toList(),
      ),
    );
  }

  Widget _buildPlayerPip(BuildContext context, Color fillColor, Color baseColor, bool filled) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(2.0),
        height: 10,
        color: filled ? fillColor : baseColor
      )
    );
  }

  Widget _buildTile(BuildContext context, String word) {
    return Container(
      padding: const EdgeInsets.all(0),
      child: Center(child: Text(word)),
      color: Colors.grey[300],
    );
  }
}
