import 'dart:math';
import 'package:flutter/material.dart';

import '../data/words.dart';
import '../models/player.dart';
import '../models/tile.dart';
import '../utils/utils.dart';

void addTilesForPlayer(Player player, List<Tile>tiles) {
  while (tiles.where((tile) => tile.owner == player).length < player.tileCount) {
    List<Tile> unassignedTiles = tiles.where((tile) => !tile.hasOwner()).toList();
    int n = Random().nextInt(unassignedTiles.length);
    Tile tile = unassignedTiles[n];
    tile.owner = player;
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

  game.currentTurnState = game.turnStates.first;
  game.currentPlayer = game.players.first;
}

Player nextPlayer(game) {
  return nextInList(game.players, game.currentPlayer);
}

bool isCodeViewing(game) {
  return game.currentTurnState == 'code_viewing';
}

String endTurnLabel(game) {
  if (!isCodeViewing(game)) {
    return "Begin Turn (View Codes 4 ${nextPlayer(game).name})";
  }
  return "End Turn (Hide Codes)";
}

void endTurn(game) {
  game.currentTurnState = nextInList(game.turnStates, game.currentTurnState);
  if (isCodeViewing(game)) {
    game.currentPlayer = nextPlayer(game);
  } else {
    game.canGuess = true;
  }
}