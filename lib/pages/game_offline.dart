import 'package:flutter/material.dart';

import '../models/player.dart';
import '../models/tile.dart';
import '../components/board.dart';
import '../components/pips.dart';
import '../components/dialogs/game_over.dart';
import '../components/dialogs/new_game.dart';
import '../utils/game.dart';

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

  @override
  void initState() {
    super.initState();

    newGame(widget);
  }

  @override
  Widget build(BuildContext context) {

    if (widget.currentPlayer == null) {
      return Scaffold(
        appBar: AppBar(title: Center(child: Text("Loading..."))),
        body: Center(child: Text("Loading..."))
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'End Turn',
            onPressed: () { setState(() => endTurn(widget) ); },
          ),
        ],
      ),
      body: Column(children: <Widget>[
        Pips(players: widget.players),
        Board(
          currentPlayer: widget.currentPlayer,
          players: widget.players,
          isCodeViewing: isCodeViewing(widget),
          tiles: widget.tiles,
          onClickTile: (Tile tile) {
            if (widget.canGuess) {
              setState(() {
                final Player player = widget.players.firstWhere((player) => player.name == tile.ownerName);
                tile.select();
                widget.canGuess = false;
                if (tile.hasOwner() && tile.ownerName == "bomb") {
                  gameOver(context, "You've bown up!");
                }
                if (tile.hasOwner() && tile.ownerName == widget.currentPlayer.name) {
                  widget.canGuess = true;
                  if (player.hasWon()) {
                    gameOver(context, "${tile.ownerName} has won!!!");
                  }
                }
              });
            }
          }
         ),
        FractionallySizedBox(
          widthFactor: 0.9,
          child: OutlineButton(
            onPressed: () { setState(() => endTurn(widget) ); },
            child: Text(endTurnLabel(widget)),
          ),
        ),
        Divider(),
        FractionallySizedBox(
          widthFactor: 0.9,
          child: OutlineButton(
            onPressed: () { neverSatisfied(context, () => setState(() => newGame(widget))); },
            child: const Text('New Game'),
          ),
        ),
      ]),
    );
  }
}
