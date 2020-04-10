import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/game.dart';
import '../models/player.dart';
import '../models/tile.dart';

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
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Player nextPlayer() {
      for (var i = 0; i < widget.game.players.length - 1; i++) {
        if (widget.game.players[i] == widget.game.currentPlayer) {
          return widget.game.players[i + 1];
        }
      }
      return widget.game.players.first;
    }

    String nextAction() {
      for (var i = 0; i < widget.turnStates.length - 1; i++) {
        if (widget.turnStates[i] == widget.game.currentTurnState) {
          return widget.turnStates[i + 1];
        }
      }
      return widget.turnStates.first;
    }

    bool isCodeViewing() {
      return widget.game.currentTurnState == 'code_viewing';
    }

    String endTurnLabel() {
      if (!isCodeViewing()) {
        return "Begin Turn (View Codes 4 ${nextPlayer().name})";
      }
      return "End Turn (Hide Codes)";
    }

    void endTurn() {
      setState(() {
        widget.game.currentTurnState = nextAction();
        if (isCodeViewing()) {
          widget.game.currentPlayer = nextPlayer();
        } else {
          widget.game.canGuess = true;
        }
      });
    }

    if (widget.game == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Loading...")),
        body: Text("Loading...")
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title} | ${widget.roomId}"),
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
          children: widget.game.players.map((player) => _buildPlayerPips(context, player)).toList()
        ),
        Expanded(
          child: Container(
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     begin: Alignment.topLeft,
            //     colors: [widget.game.currentPlayer.baseColor, widget.game.currentPlayer.fillColor], // TODO
            //   )
            // ),
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(0),
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
              crossAxisCount: 5,
              children:
                widget.game.tiles.map((tile) => _buildTile(context, tile)).toList(),
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
      return widget.game.currentPlayer == owner;// || owner.name == 'bomb'; // coop can't see bombs
    }

    // DUP
    bool isCodeViewing() {
      return widget.game.currentTurnState == 'code_viewing';
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
      if (widget.game.canGuess) {
        setState(() {
          tile.select();
          widget.game.canGuess = false;
          if (tile.hasOwner() && tile.owner.name == "bomb") {
            _gameOver("You've bown up!");
          }
          if (tile.hasOwner() && tile.owner == widget.game.currentPlayer) {
            widget.game.canGuess = true;
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
