import 'package:flutter/material.dart';

import './player.dart';
import './tile.dart';

class Game {
  String roomId;
  List<Tile> tiles;
  List<Player> players;
  List<Player> bombs;
  List<String> turnStates;
  String currentTurnState;
  Player currentPlayer;
  bool canGuess;

  Game(
    String roomId,
    List<Tile> tiles,
    List<Player> players,
    List<Player> bombs,
    String currentTurnState,
    Player currentPlayer,
    bool canGuess,
  ) {
    this.roomId = roomId;
    this.tiles = tiles;
    this.players = players;
    this.bombs = bombs;
    this.currentTurnState = currentTurnState;
    this.currentPlayer = currentPlayer;
    this.canGuess = canGuess;

    this.turnStates = ['code_viewing', 'guessing'];
  }

  factory Game.fromMap(Map<String, dynamic> map) { //, {this.reference})
    assert(map['roomId'] != null);
    assert(map['tiles'] != null);
    assert(map['players'] != null);
    assert(map['bombs'] != null);
    assert(map['currentTurnState'] != null);
    assert(map['currentPlayer'] != null);
    assert(map['canGuess'] != null);

    List<Tile> tiles = List();
    for (var i = 0; i < map['tiles'].length; i++) {
      Tile tile = Tile.fromMap(map['tiles'][i]);
      tiles.add(tile);
    }

    List<Player> players = List();
    for (var i = 0; i < map['players'].length; i++) {
      Player player = Player.fromMap(map['players'][i]);
      players.add(player);
    }

    List<Player> bombs = List();
    for (var i = 0; i < map['bombs'].length; i++) {
      Player bomb = Player.fromMap(map['bombs'][i]);
      bombs.add(bomb);
    }

    return new Game(
      map['roomId'],
      tiles,
      players,
      bombs,
      map['currentTurnState'],
      Player.fromMap(map['currentPlayer']),
      map['canGuess'],
    );
  }

  // Player.fromSnapshot(DocumentSnapshot snapshot)
  //    : this.fromMap(snapshot.data, reference: snapshot.reference);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> toReturn = new Map();
    toReturn['roomId'] = roomId;
    toReturn['tiles'] = tiles.map((tile) => tile.toMap()).toList();
    toReturn['players'] = players.map((player) => player.toMap()).toList();
    toReturn['bombs'] = bombs.map((bomb) => bomb.toMap()).toList();
    toReturn['currentTurnState'] = currentTurnState;
    toReturn['currentPlayer'] = currentPlayer.toMap();
    toReturn['canGuess'] = canGuess;
    return toReturn;
  }

  @override
  String toString() => "Player<$roomId>";
}
