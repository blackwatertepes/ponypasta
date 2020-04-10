import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../data/words.dart';
import '../models/game.dart';
import '../models/player.dart';
import '../models/tile.dart';
import '../components/board.dart';

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

  @override
  _GamePageState createState() => _GamePageState();
}

// TODO: Refactor into sharable components between both game pages

class _GamePageState extends State<GameOnlinePage> {

  DatabaseReference _gameRef;

  void _addTilesForPlayer(player) {
    while (widget.tiles.where((tile) => tile.owner == player).length < player.tileCount) {
      List<Tile> unassignedTiles = widget.tiles.where((tile) => !tile.hasOwner()).toList();
      int n = Random().nextInt(unassignedTiles.length);
      Tile tile = unassignedTiles[n];
      tile.owner = player;
    }
  }

  void _resetGame() {
    widget.tiles = getRandomWords(words(), 25).map((word) => Tile.fromWord(word)).toList();
    widget.players = [
      new Player('red', Colors.red[100], Colors.red, 7), // 9 for normal
      new Player('blue', Colors.blue[100], Colors.blue, 6), // 8 for normal
    ];
    widget.bombs = [ // 1 bomb for normal game play
      new Player('bomb', Colors.grey, Colors.grey, 1),
      new Player('bomb', Colors.grey, Colors.grey, 1),
    ];

    widget.players.forEach((player) => _addTilesForPlayer(player));
    widget.bombs.forEach((player) => _addTilesForPlayer(player));

    widget.currentTurnState = widget.turnStates.first;
    widget.currentPlayer = widget.players.first;
  }

  @override
  void initState() {
    super.initState();

    _resetGame();
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
    });
    database.setPersistenceEnabled(true);
    // database.setPersistenceCacheSizeBytes(1000000);
    _gameRef.keepSynced(true);

    final TransactionResult transactionResult = 
      await _gameRef.runTransaction((MutableData mutableData) async {
        mutableData.value = game.toMap();
        return mutableData;
      });
    
    if (transactionResult.committed) {
      print("Write success!");
      print(transactionResult.dataSnapshot.value);
    } else {
      print("Write failure!");
      if (transactionResult.error != null) {
        print(transactionResult.error.message);
      }
    }
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
          children: widget.players.map((player) => _buildPlayerPips(context, player)).toList()
        ),
        Board(
          currentPlayer: widget.currentPlayer,
          isCodeViewing: isCodeViewing(),
          tiles: widget.tiles,
          onClickTile: (Tile tile) {
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
}
