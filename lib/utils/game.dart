import 'dart:math';
import 'package:flutter/material.dart';

import '../data/words.dart';
import '../models/player.dart';
import '../models/tile.dart';


void addTilesForPlayer(Player player, List<Tile>tiles) {
  while (tiles.where((tile) => tile.ownerName == player.name).length < player.tileCount) {
    List<Tile> unassignedTiles = tiles.where((tile) => !tile.hasOwner()).toList();
    int n = Random().nextInt(unassignedTiles.length);
    Tile tile = unassignedTiles[n];
    tile.ownerName = player.name;
  }
}

void newGame(game) {
  game.tiles = getRandomWords(words(), 25).map((word) => Tile.fromWord(word)).toList();
  game.players = [
    new Player('red', Colors.red[100], Colors.red, 7), // 9 for normal
    new Player('blue', Colors.blue[100], Colors.blue, 6), // 8 for normal
  ];
  game.bombs = [ // 1 bomb for normal game play
    new Player('bomb', Colors.grey, Colors.grey, 1),
    new Player('bomb', Colors.grey, Colors.grey, 1),
  ];

  game.players.forEach((player) => addTilesForPlayer(player, game.tiles));
  game.bombs.forEach((player) => addTilesForPlayer(player, game.tiles));

  game.currentPlayer = game.players.first;
}