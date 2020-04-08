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
  final List<String> turnStates = ['code_viewing', 'guessing'];

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

    Player nextPlayer() {
      for (var i = 0; i < widget.players.length - 1; i++) {
        if (widget.players[i] == widget.currentPlayer) {
          return widget.players[i + 1];
        }
      }
      return widget.players.first;
    }

    String nextAction() {
      for (var i = 0; i < widget.turnStates.length - 1; i++) {
        if (widget.turnStates[i] == widget.currentTurnState) {
          return widget.turnStates[i + 1];
        }
      }
      return widget.turnStates.first;
    }

    bool isCodeViewing() {
      return widget.currentTurnState == 'code_viewing';
    }

    String endTurnLabel() {
      if (!isCodeViewing()) {
        return "Begin Turn (View Codes 4 ${nextPlayer().name})";
      }
      return "End Turn (Hide Codes)";
    }

    void endTurn() {
      setState(() {
        widget.currentTurnState = nextAction();
        if (isCodeViewing()) {
          widget.currentPlayer = nextPlayer();
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
                colors: [widget.currentPlayer.baseColor, widget.currentPlayer.fillColor], // TODO
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
    bool canViewTile(Player owner) {
      return widget.currentPlayer == owner || owner.name == 'bomb';
    }

    bool isCodeViewing() {
      return widget.currentTurnState == 'code_viewing';
    }

    Color tileColor(Tile tile) {
      if (tile.hasOwner() && ((isCodeViewing() && canViewTile(tile.owner)) || tile.selected)) {
        return tile.owner.baseColor;
      }
      return Colors.grey[300];
    }

    return Container(
      padding: const EdgeInsets.all(0),
      child: Center(child: Text(tile.name, style: new TextStyle(decoration: tile.isSelected() ? TextDecoration.lineThrough : TextDecoration.none))),
      color: tileColor(tile),
    );
  }
}
