import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';

import '../data/words.dart';
import '../models/player.dart';
import '../models/tile.dart';

class GamePage extends StatefulWidget {
  GamePage({Key key, this.title}) : super(key: key);

  final String title;
  final Player bomb = Player('bomb', Colors.grey, Colors.grey, 1);
  final Set<String> turnStates = Set.from(['code_viewing', 'guessing']);

  List<Tile> tiles = List();
  List<Player> players = List();
  String currentTurnState;
  Player currentPlayer;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  @override
  Widget build(BuildContext context) {

    void resetGame() {
      setState(() {
        widget.tiles = getRandomWords(words(), 25).map((word) => Tile.fromWord(word)).toList();
        widget.players = [
          new Player('red', Colors.red[100], Colors.red, 9),
          new Player('blue', Colors.blue[100], Colors.blue, 8),
        ];

        List<Player> entities = widget.players.toList();
        entities.add(widget.bomb);
        entities.forEach((player) {
          while (widget.tiles.where((tile) => tile.owner == player).length < player.tileCount) {
            List<Tile> unassignedTiles = widget.tiles.where((tile) => !tile.hasOwner()).toList();
            int n = Random().nextInt(unassignedTiles.length);
            Tile tile = unassignedTiles[n];
            tile.owner = player;
          }
        });

        widget.currentTurnState = widget.turnStates.first;
        widget.currentPlayer = widget.players.first;
      });
    }

    if (widget.currentPlayer == null) {
      resetGame();
    }

    String endTurnLabel() {
      if (widget.currentTurnState == 'code_viewing') {
        return "End Turn (Hide Codes)";
      } else if (widget.currentTurnState == 'guessing') {
        return "Begin Turn (View Codes)";//" 4 ${nextPlayer.name})";
      }
    }

    void endTurn() {
      // TODO: Clean up with lists, and next interations
      setState(() {
        if (widget.currentTurnState == 'code_viewing') {
          widget.currentTurnState = 'guessing';
          if (widget.currentPlayer == widget.players[0]) {
            widget.currentPlayer = widget.players[1];
          } else {
            widget.currentPlayer = widget.players[0];
          }
        } else if (widget.currentTurnState == 'guessing') {
          widget.currentTurnState = 'code_viewing';
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'End Turn',
            onPressed: () {
              endTurn();
            },
          ),
        ],
      ),
      body: Column(children: <Widget>[
        Row(
          children: widget.players.map((player) => _buildPlayerPips(context, player)).toList()
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                colors: [widget.players[0].baseColor, widget.players[0].fillColor], // TODO
              )
            ),
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(0),
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
              crossAxisCount: 5,
              children:
                widget.tiles.map((tile) => _buildTile(context, tile)).toList(),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: RaisedButton(
            onPressed: () { endTurn(); },
            child: Text(endTurnLabel()),
          ),
        ),
        Divider(),
        SizedBox(
          width: double.infinity,
          child: RaisedButton(
            onPressed: () { resetGame(); },
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
