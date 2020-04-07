import 'package:flutter/material.dart';

import '../data/words.dart';

class GamePage extends StatefulWidget {
  GamePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> wordList = getRandomWords(words(), 25);

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(0),
          crossAxisSpacing: 3,
          mainAxisSpacing: 3,
          crossAxisCount: 5,
          children: wordList.map((word) => _buildTile(context, word)).toList(),
        ));
  }

  Widget _buildTile(BuildContext context, String word) {
    return Container(
      padding: const EdgeInsets.all(0),
      child: Center(child: Text(word)),
      color: Colors.grey[300],
    );
  }
}
