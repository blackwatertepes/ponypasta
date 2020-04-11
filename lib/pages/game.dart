import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/game.dart';
import '../models/tile.dart';
import '../components/Board.dart';
import '../components/Pips.dart';
import '../components/dialogs/game_over.dart';
import '../utils/game.dart';

class GamePage extends StatefulWidget {
  GamePage({Key key, this.title, this.roomId}) : super(key: key);

  final String title;
  final String roomId;
  final List<String> turnStates = ['code_viewing', 'guessing'];
  Game game;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  @override
  void initState() {
    super.initState();

    _getRoom();
  }

  Future<void> _getRoom() async {
    WidgetsFlutterBinding.ensureInitialized();
    CollectionReference _gamesCol = Firestore.instance.collection("games");

    _gamesCol.where("roomId", isEqualTo: widget.roomId).snapshots().listen((data) {
      data.documents.forEach((doc) => doc["roomId"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('games').where("roomId", isEqualTo: '753773').snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        print("Data: ${snapshot.data.documents[0].data}");
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default: return buildGame(context, Game.fromMap(snapshot.data.documents[0].data));
        }
      }
    );
  }

  Widget buildGame(BuildContext context, Game game) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("${widget.title} | ${widget.roomId}")),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'End Turn',
            onPressed: () { setState(() => endTurn(game));
            },
          ),
        ],
      ),
      body: Column(children: <Widget>[
        Pips(players: game.players),
        Board(
          currentPlayer: game.currentPlayer,
          isCodeViewing: isCodeViewing(game),
          tiles: game.tiles,
          onClickTile: (Tile tile) {
            if (game.canGuess) {
              setState(() {
                tile.select();
                game.canGuess = false;
                if (tile.hasOwner() && tile.owner.name == "bomb") {
                  gameOver(context, "You've bown up!");
                }
                if (tile.hasOwner() && tile.owner.name == game.currentPlayer.name) {
                  game.canGuess = true;
                  if (tile.owner.hasWon()) {
                    gameOver(context, "${tile.owner.name} has won!!!");
                  }
                }
              });
            }
          }
         ),
        FractionallySizedBox(
          widthFactor: 0.9,
          child: OutlineButton(
            onPressed: () { setState(() => endTurn(game)); },
            child: Text(endTurnLabel(game)),
          ),
        ),
      ]),
    );
  }
}
