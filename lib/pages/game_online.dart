import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/game.dart';
import '../models/player.dart';
import '../models/tile.dart';
import '../components/board.dart';
import '../components/pips.dart';
import '../components/dialogs/game_over.dart';
import '../components/dialogs/new_game.dart';
import '../utils/game.dart';

class GameOnlinePage extends StatefulWidget {
  GameOnlinePage({Key key, this.title, this.roomId}) : super(key: key);

  final String title;
  final String roomId;
  final List<String> turnStates = ['code_viewing', 'guessing'];
  List<Tile> tiles = List();
  List<Player> players = List();
  List<Player> bombs = List();
  String currentTurnState;
  Player currentPlayer;
  bool canGuess = false;
  int gameRoomId = 0;
  DocumentReference gameDoc;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GameOnlinePage> {

  @override
  void initState() {
    super.initState();

    newGame(widget);
    _createRoom();
  }

  Future<void> _createRoom() async {
    Game game = Game(
      widget.roomId,
      widget.tiles,
      widget.players,
      widget.bombs,
      widget.currentTurnState,
      widget.currentPlayer,
      widget.canGuess,
    );

    WidgetsFlutterBinding.ensureInitialized();
    CollectionReference _gamesCol = Firestore.instance.collection("games");

    widget.gameDoc = await _gamesCol.add(game.toMap());
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _updateRoom() async {
      Game game = Game(
        widget.roomId,
        widget.tiles,
        widget.players,
        widget.bombs,
        widget.currentTurnState,
        widget.currentPlayer,
        widget.canGuess,
      );

      await widget.gameDoc.updateData(game.toMap());
    }

    if (widget.currentPlayer == null) {
      setState(() {
        newGame(widget);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("${widget.title} | ${widget.roomId}")),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'End Turn',
            onPressed: () { setState(() => endTurn(widget));
            },
          ),
        ],
      ),
      body: Column(children: <Widget>[
        Pips(players: widget.players),
        Board(
          currentPlayer: widget.currentPlayer,
          isCodeViewing: isCodeViewing(widget),
          tiles: widget.tiles,
          onClickTile: (Tile tile) {
            if (widget.canGuess) {
              setState(() {
                tile.select();
                widget.canGuess = false;
                if (tile.hasOwner() && tile.owner.name == "bomb") {
                  gameOver(context, "You've bown up!");
                }
                if (tile.hasOwner() && tile.owner == widget.currentPlayer) {
                  widget.canGuess = true;
                  if (tile.owner.hasWon()) {
                    gameOver(context, "${tile.owner.name} has won!!!");
                  }
                }
              });
              _updateRoom();
            }
          }
        ),
        FractionallySizedBox(
          widthFactor: 0.9,
          child: OutlineButton(
            onPressed: () { setState(() => endTurn(widget)); },
            child: Text(endTurnLabel(widget)),
          ),
        ),
        Divider(),
        FractionallySizedBox(
          widthFactor: 0.9,
          child: OutlineButton(
            onPressed: () { neverSatisfied(context, () {
              setState(() => newGame(widget));
              _updateRoom();
            }); },
            child: const Text('New Game'),
          ),
        ),
      ]),
    );
  }
}
