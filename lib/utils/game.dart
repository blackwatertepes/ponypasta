import 'dart:math';

import '../models/tile.dart';

void addTilesForPlayer(player, tiles) {
  while (tiles.where((tile) => tile.owner == player).length < player.tileCount) {
    List<Tile> unassignedTiles = tiles.where((tile) => !tile.hasOwner()).toList();
    int n = Random().nextInt(unassignedTiles.length);
    Tile tile = unassignedTiles[n];
    tile.owner = player;
  }
}