import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';

import '../data/words.dart';
import '../models/player.dart';
import '../models/tile.dart';

class GameOfflinePage extends StatefulWidget {
  GameOfflinePage({Key key, this.title}) : super(key: key);

  final String title;
  final List<String> turnStates = ['code_viewing', 'guessing'];

  List<Tile> tiles = List();
  List<Player> players = List();
  List<Player> bombs = List();
  String currentTurnState;
  Player currentPlayer;
  bool canGuess = false;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GameOfflinePage> {

  Future<void> _neverSatisfied(resetGame) async {
    String body() {
      return 'You will never be satisfied.';
    }

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Start a new Game'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(body()),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('New Game'),
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    void addTilesForPlayer(player) {
      while (widget.tiles.where((tile) => tile.owner == player).length < player.tileCount) {
        List<Tile> unassignedTiles = widget.tiles.where((tile) => !tile.hasOwner()).toList();
        int n = Random().nextInt(unassignedTiles.length);
        Tile tile = unassignedTiles[n];
        tile.owner = player;
      }
    }

    void resetGame() {
      setState(() {
        widget.tiles = getRandomWords(words(), 25).map((word) => Tile.fromWord(word)).toList();
        widget.players = [
          new Player('red', Colors.red[100], Colors.red, 7), // 9 for normal
          new Player('blue', Colors.blue[100], Colors.blue, 6), // 8 for normal
        ];
        widget.bombs = [ // 1 bomb for normal game play
          new Player('bomb', Colors.grey, Colors.grey, 1),
          new Player('bomb', Colors.grey, Colors.grey, 1),
        ];

        widget.players.forEach((player) => addTilesForPlayer(player));
        widget.bombs.forEach((player) => addTilesForPlayer(player));

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
        } else {
          widget.canGuess = true;
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
        FractionallySizedBox(
          widthFactor: 0.9,
          child: OutlineButton(
            onPressed: () { endTurn(); },
            child: Text(endTurnLabel()),
          ),
        ),
        Divider(),
        FractionallySizedBox(
          widthFactor: 0.9,
          child: OutlineButton(
            onPressed: () { _neverSatisfied(resetGame); },
            child: const Text('New Game'),
          ),
        ),
      ]),
    );
  }

  Widget _buildPlayerPips(BuildContext context, Player player) {
    return Expanded(
      child: Row(
        children: player.pips().map((filled) => _buildPlayerPip(context, player.fillColor, player.baseColor, filled)).toList(),
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

    Future<void> _gameOver(String title) async {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            actions: <Widget>[
              FlatButton(
                child: Text('Next'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    bool canViewTile(Player owner) {
      return widget.currentPlayer == owner;// || owner.name == 'bomb'; // coop can't see bombs
    }

    // DUP
    bool isCodeViewing() {
      return widget.currentTurnState == 'code_viewing';
    }

    Color tileColor() {
      if (tile.hasOwner() && ((isCodeViewing() && canViewTile(tile.owner)) || tile.selected)) {
        return tile.owner.baseColor;
      }
      return Colors.grey[300];
    }

    Color iconColor() {
      if (tile.hasOwner() && ((isCodeViewing() && canViewTile(tile.owner)) || tile.selected)) {
        return tile.owner.fillColor;
      }
      return Colors.grey[300];
    }

    void clickTile() {
      if (widget.canGuess) {
        setState(() {
          tile.select();
          widget.canGuess = false;
          if (tile.hasOwner() && tile.owner.name == "bomb") {
            _gameOver("You've bown up!");
          }
          if (tile.hasOwner() && tile.owner == widget.currentPlayer) {
            widget.canGuess = true;
            if (tile.owner.hasWon()) {
              _gameOver("${tile.owner.name} has won!!!");
            }
          }
        });
      }
    }

    return FlatButton(
      padding: const EdgeInsets.all(0),
      child: Center(
        child: !tile.selected ?
          Text(tile.name) :
          Icon(Icons.check_circle, color: iconColor()),
      ),
      color: tileColor(),
      onPressed: () { clickTile(); }
    );
  }
}
