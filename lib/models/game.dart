import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import './player.dart';
import './tile.dart';

class Game {
  String roomId;
  List<Tile> tiles;
  List<Player> players;
  List<Player> bombs;
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
  }

  Game.fromMap(Map<String, dynamic> map)//, {this.reference})
     : assert(map['roomId'] != null),
       assert(map['tiles'] != null),
       assert(map['players'] != null),
       assert(map['bombs'] != null),
       assert(map['currentTurnState'] != null),
       assert(map['currentPlayer'] != null),
       assert(map['canGuess'] != null),
       roomId = map['roomId'],
       tiles = map['tiles'],
       players = map['players'],
       bombs = map['bombs'],
       currentTurnState = map['currentTurnState'],
       currentPlayer = map['currentPlayer'],
       canGuess = map['canGuess'];

  // Player.fromSnapshot(DocumentSnapshot snapshot)
  //    : this.fromMap(snapshot.data, reference: snapshot.reference);

  Map toMap() {
    Map toReturn = new Map();
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
