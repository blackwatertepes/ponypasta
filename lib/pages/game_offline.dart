import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';

import '../data/words.dart';
import '../models/player.dart';
import '../models/tile.dart';
import '../components/board.dart';
import '../components/pips.dart';

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
        Pips(players: widget.players),
        Board(
          currentPlayer: widget.currentPlayer,
          isCodeViewing: isCodeViewing(),
          tiles: widget.tiles,
          onClickTile: (Tile tile) {
            setState(() {
              if (widget.canGuess) {
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
              }
            });
          }
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
}
