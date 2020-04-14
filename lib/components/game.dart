import 'package:flutter/material.dart';

import '../models/game.dart';
import '../models/player.dart';
import '../models/tile.dart';
import '../components/Board.dart';
import '../components/Pips.dart';
import '../components/dialogs/game_over.dart';
import '../services/database.dart';

class GamePage extends StatelessWidget {
  final String title;
  final String roomId;
  final String isPlayer;
  Game game;

  GamePage({Key key, this.title, this.roomId, this.isPlayer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseService.stream(this.roomId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        if (snapshot.connectionState == ConnectionState.waiting) return new Text('Loading...');
        if (snapshot.data.documents.length > 0) return buildGame(context, Game.fromMap(snapshot.data.documents.first.data));
        return new Text("Something went wrong!");
      }
    );
  }

  Widget buildGame(BuildContext context, Game game) {
    Player _isPlayer() {
      return game.players.firstWhere((player) => player.name == this.isPlayer);
    }

    bool _isCurrent() {
      return game.currentPlayer.name == this.isPlayer;
    }

    String _endTurnLabel() {
      if (!_isCurrent()) {
        return "Waiting on ${game.nextPlayer().name}...";
      }
      return "End Turn";
    }

    void _endTurn() {
      if (_isCurrent()) {
        game.endTurn();
        DatabaseService.updateRoom(game);
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
