import 'dart:convert';
import 'package:flutter/material.dart';

import '../data/words.dart';

class GamePage extends StatefulWidget {
  GamePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<bool> redPips = List.from([true, true, true, false, false, false, false, false, false]);
  List<bool> bluePips = List.from([false, false, false, false, false, false, false, false, false]);

  @override
  Widget build(BuildContext context) {
    List<String> wordList = getRandomWords(words(), 25);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'End Turn',
            onPressed: () {
              // openPage(context);
            },
          ),
        ],
      ),
      body: Column(children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: redPips.map((filled) => _buildPlayerPip(context, Colors.red, Colors.red[100], filled)).toList(),
              ),
            ),
            Expanded(
              child: Row(
                children: bluePips.map((filled) => _buildPlayerPip(context, Colors.blue, Colors.blue[200], filled)).toList(),
              ),
            ),
          ],
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
            onPressed: () {},
            child: const Text('End Turn'),
            color: Colors.red[200],
          ),
        ),
        Divider(),
        SizedBox(
          width: double.infinity,
          child: RaisedButton(
            onPressed: () {},
            child: const Text('New Game'),
          ),
        ),
      ]),
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
