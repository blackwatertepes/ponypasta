import 'package:flutter/material.dart';

import '../data/words.dart';
import '../models/player.dart';
import '../models/tile.dart';
import '../components/board.dart';
import '../components/pips.dart';
import '../components/dialogs/game_over.dart';
import '../components/dialogs/new_game.dart';
import '../utils/game.dart';
import '../utils/utils.dart';

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

  // @override
  // void initState() {
  //   super.initState();

  //   newGame(widget);
  // }

  @override
  Widget build(BuildContext context) {
    void newGame(game) {
      game.tiles = getRandomWords(words(), 25).map((word) => Tile.fromWord(word)).toList();
      game.players = [
        new Player('red', Colors.red[100], Colors.red, 7), // 9 for normal
        new Player('blue', Colors.blue[100], Colors.blue, 6), // 8 for normal
      ];
      game.bombs = [ // 1 bomb for normal game play
        new Player('bomb', Colors.grey, Colors.grey, 1),
        new Player('bomb', Colors.grey, Colors.grey, 1),
      ];

      game.players.forEach((player) => addTilesForPlayer(player, game.tiles));
      game.bombs.forEach((player) => addTilesForPlayer(player, game.tiles));

      game.currentTurnState = game.turnStates.first;
      game.currentPlayer = game.players.first;
    }

    if (widget.currentPlayer == null) {
      newGame(widget);
    }

    Player _nextPlayer(game) {
      return nextInList(game.players, game.currentPlayer);
    }

    bool _isCodeViewing(game) {
      return game.currentTurnState == 'code_viewing';
    }

    String _endTurnLabel(game) {
      if (!_isCodeViewing(game)) {
        return "Begin Turn (View Codes 4 ${_nextPlayer(game).name})";
      }
      return "End Turn (Hide Codes)";
    }

    void _endTurn(game) {
      game.currentTurnState = nextInList(game.turnStates, game.currentTurnState);
      if (_isCodeViewing(game)) {
        game.currentPlayer = _nextPlayer(game);
      } else {
        game.canGuess = true;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'End Turn',
            onPressed: () { setState(() => _endTurn(widget) ); },
          ),
        ],
      ),
      body: Column(children: <Widget>[
        Pips(players: widget.players),
        Board(
          currentPlayer: widget.currentPlayer,
          players: widget.players,
          isCodeViewing: _isCodeViewing(widget),
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
            onPressed: () { setState(() => _endTurn(widget) ); },
            child: Text(_endTurnLabel(widget)),
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
