import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';

import '../data/words.dart';
import '../models/player.dart';
import '../models/tile.dart';

class GamePage extends StatefulWidget {
  GamePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  @override
  Widget build(BuildContext context) {
    List<String> wordList;
    List<Tile> tiles;
    List<Player> players;
    Player bomb;

    // enum TurnState {
    //   codeviewing,
    //   guessing,
    // }

    resetGame() {
      setState(() {
        wordList = getRandomWords(words(), 25);
        tiles = wordList.map((word) => Tile.fromWord(word)).toList();

        players = [
          new Player('red', Colors.red[100], Colors.red, 9),
          new Player('blue', Colors.blue[100], Colors.blue, 8),
        ];

        bomb = Player('bomb', Colors.grey, Colors.grey, 1);

        List<Player> entities = players.toList();
        entities.add(bomb);
        entities.forEach((player) {
          while (tiles.where((tile) => tile.owner == player).length < player.tileCount) {
            List<Tile> unassignedTiles = tiles.where((tile) => !tile.hasOwner()).toList();
            int n = Random().nextInt(unassignedTiles.length);
            Tile tile = unassignedTiles[n];
            tile.owner = player;
          }
        });
      });
    }

    resetGame();

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
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                colors: [players[0].baseColor, players[0].fillColor], // TODO
              )
            ),
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(0),
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
              crossAxisCount: 5,
              children:
                tiles.map((tile) => _buildTile(context, tile)).toList(),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: RaisedButton(
            onPressed: () {
              // End turn
            },
            child: const Text('End Turn'),
          ),
        ),
        Divider(),
        SizedBox(
          width: double.infinity,
          child: RaisedButton(
            onPressed: () {
              resetGame();
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

  Widget _buildTile(BuildContext context, Tile tile) {
    return Container(
      padding: const EdgeInsets.all(0),
      child: Center(child: Text(tile.name, style: new TextStyle(decoration: tile.isSelected() ? TextDecoration.lineThrough : TextDecoration.none))),
      color: tile.hasOwner() ? tile.owner.baseColor : Colors.grey[300],
    );
  }
}
