import 'dart:math';
import 'package:flutter/material.dart';

import '../data/words.dart';
import '../models/player.dart';
import '../models/tile.dart';
import './player.dart';
import './tile.dart';
import '../utils.dart';

class Game {
  String roomId;
  List<Tile> tiles;
  List<Player> players;
  List<Player> bombs;
  List<String> turnStates;
  Player currentPlayer;

  Game(
    String roomId,
    List<Tile> tiles,
    List<Player> players,
    List<Player> bombs,
    Player currentPlayer,
  ) {
    this.roomId = roomId;
    this.tiles = tiles;
    this.players = players;
    this.bombs = bombs;
    this.currentPlayer = currentPlayer;
  }

  static addTilesForPlayer(Player player, List<Tile>tiles) {
    while (tiles.where((tile) => tile.ownerName == player.name).length < player.tileCount) {
      List<Tile> unassignedTiles = tiles.where((tile) => !tile.hasOwner()).toList();
      int n = Random().nextInt(unassignedTiles.length);
      Tile tile = unassignedTiles[n];
      tile.ownerName = player.name;
    }
  }

  static generate(String roomId) {
    List<Tile> tiles = getRandomWords(words(), 25).map((word) => Tile.fromWord(word)).toList();

    List<Player> players = [
      new Player('red', Colors.red[100], Colors.red, 7), // 9 for normal
      new Player('blue', Colors.blue[100], Colors.blue, 6), // 8 for normal
    ];

    List<Player> bombs = [ // 1 bomb for normal game play
      new Player('bomb', Colors.grey, Colors.grey, 1),
      new Player('bomb', Colors.grey, Colors.grey, 1),
    ];

    players.forEach((player) => addTilesForPlayer(player, tiles));
    bombs.forEach((player) => addTilesForPlayer(player, tiles));

    return new Game(
      roomId,
      tiles,
      players,
      bombs,
      players.first,
    );
  }

  Player nextPlayer() {
    String playerName = nextInList(this.players.map((player) => player.name).toList(), this.currentPlayer.name);
    return this.players.firstWhere((player) => player.name == playerName);
  }

  void endTurn() {
    currentPlayer = nextPlayer();
  }

  factory Game.fromMap(Map<String, dynamic> map) { //, {this.reference})
    assert(map['roomId'] != null);
    assert(map['tiles'] != null);
    assert(map['players'] != null);
    assert(map['bombs'] != null);
    assert(map['currentPlayer'] != null);

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
      Player.fromMap(map['currentPlayer']),
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
    toReturn['currentPlayer'] = currentPlayer.toMap();
    return toReturn;
  }

  @override
  String toString() => "Player<$roomId>";
}
