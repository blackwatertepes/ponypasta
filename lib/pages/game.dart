import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

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

// TODO: Refactor into sharable components between both game pages

class _GamePageState extends State<GamePage> {

  DatabaseReference _gameRef;

  @override
  void initState() {
    super.initState();

    _getRoom();
  }

  Future<void> _getRoom() async {

    WidgetsFlutterBinding.ensureInitialized();
    final FirebaseApp app = await FirebaseApp.configure(
      name: 'db2',
      options: Platform.isIOS
          ? const FirebaseOptions(
              googleAppID: '1:1075489014656:ios:42b6bc3b0339e51bb83765',
              gcmSenderID: '297855924061',
              databaseURL: 'https://codefriendsflutter.firebaseio.com',
            )
          : const FirebaseOptions(
              googleAppID: '1:1075489014656:android:d7b35721f72ffe60b83765',
              apiKey: 'AIzaSyB7HTRLtO24bEW6HIlE0yfA7Bh1HmlKyUo',
              databaseURL: 'https://codefriendsflutter.firebaseio.com',
            ),
    );

    _gameRef = FirebaseDatabase.instance.reference().child("game-${widget.roomId}");
    final FirebaseDatabase database = FirebaseDatabase(app: app);
    database.reference().child("game-${widget.roomId}").once().then((DataSnapshot snapshot) {
      print("Connected to second database and read ${snapshot.value}");
      print("currentTurnState: ${snapshot.value['currentTurnState']}");
      print("canGuess: ${snapshot.value['canGuess']}");
      print("roomId: ${snapshot.value['roomId']}");
      print("Game: ${Game.fromMap(snapshot.value)}");
      setState(() {
        widget.game = Game.fromMap(snapshot.value);
      });
    });
    database.setPersistenceEnabled(true);
    // database.setPersistenceCacheSizeBytes(1000000);
    _gameRef.keepSynced(true);

    _gameRef.onValue.listen((Event event) {
      print("Event: ${event}");
      // setState(() {
      //   _error = null;
      //   _counter = event.snapshot.value ?? 0;
      // });
    }, onError: (Object o) {
      print("Error: ${o}");
      // final DatabaseError error = o;
      // setState(() {
      //   _error = error;
      // });
    });
  }

  @override
  Widget build(BuildContext context) {

    if (widget.game == null) {
      return Scaffold(
        appBar: AppBar(title: Center(child: Text("Loading..."))),
        body: Center(child: Text("Loading..."))
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("${widget.title} | ${widget.roomId}")),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'End Turn',
            onPressed: () { setState(() => endTurn(widget.game));
            },
          ),
        ],
      ),
      body: Column(children: <Widget>[
        Pips(players: widget.game.players),
        Board(
          currentPlayer: widget.game.currentPlayer,
          isCodeViewing: isCodeViewing(widget.game),
          tiles: widget.game.tiles,
          onClickTile: (Tile tile) {
            if (widget.game.canGuess) {
              setState(() {
                tile.select();
                widget.game.canGuess = false;
                if (tile.hasOwner() && tile.owner.name == "bomb") {
                  gameOver(context, "You've bown up!");
                }
                if (tile.hasOwner() && tile.owner == widget.game.currentPlayer) {
                  widget.game.canGuess = true;
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
            onPressed: () { setState(() => endTurn(widget.game)); },
            child: Text(endTurnLabel(widget.game)),
          ),
        ),
      ]),
    );
  }
}
