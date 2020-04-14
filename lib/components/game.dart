import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/game.dart';
import '../models/player.dart';
import '../models/tile.dart';
import '../components/Board.dart';
import '../components/Pips.dart';
import '../components/dialogs/game_over.dart';
import '../utils/utils.dart';

class GamePage extends StatefulWidget {
  GamePage({Key key, this.title, this.roomId, this.isPlayer}) : super(key: key);

  final String title;
  final String roomId;
  final String isPlayer;
  Game game;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('games').where("roomId", isEqualTo: widget.roomId).limit(1).snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        if (snapshot.connectionState == ConnectionState.waiting) return new Text('Loading...');
        if (snapshot.data.documents.length > 0) return buildGame(context, Game.fromMap(snapshot.data.documents.first.data));
        return new Text("Something went wrong!");
      }
    );
  }

  Widget buildGame(BuildContext context, Game game) {
    Future<void> _updateRoom() async {
      WidgetsFlutterBinding.ensureInitialized();
      CollectionReference _gamesCol = Firestore.instance.collection("games");

      QuerySnapshot _query = await _gamesCol.where("roomId", isEqualTo: widget.roomId).limit(1).getDocuments();
      if (_query.documents.length > 0) {
        DocumentReference _docRef = _gamesCol.document(_query.documents.first.documentID);
        await _docRef.updateData(game.toMap());
      }
    }

    Player _isPlayer() {
      return game.players.firstWhere((player) => player.name == widget.isPlayer);
    }

    bool _isCurrent() {
      return game.currentPlayer.name == widget.isPlayer;
    }

    Player _nextPlayer(game) {
      String playerName = nextInList(game.players.map((player) => player.name).toList(), game.currentPlayer.name);
      return game.players.firstWhere((player) => player.name == playerName);
    }

    String _endTurnLabel() {
      if (!_isCurrent()) {
        return "Waiting on ${_nextPlayer(game).name}...";
      }
      return "End Turn";
    }

    void _endTurn() {
      if (_isCurrent()) {
        game.currentPlayer = _nextPlayer(game);
        _updateRoom();
      }
    }

    return Column(children: <Widget>[
      Pips(players: game.players),
      Board(
        currentPlayer: _isPlayer(),
        players: game.players,
        isCodeViewing: true,
        tiles: game.tiles,
        onClickTile: (Tile tile) {
          if (_isCurrent()) {
            setState(() {
              final Player player = game.players.firstWhere((player) => player.name == tile.ownerName);
              player.incScore();
              tile.select();
              if (tile.hasOwner() && tile.ownerName == "bomb") {
                gameOver(context, "You've bown up!");
              }
              if (tile.hasOwner() && tile.ownerName == game.currentPlayer.name) {
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
          onPressed: () { _endTurn(); },
          child: Text(_endTurnLabel()),
        ),
      ),
    ]);
  }
}
