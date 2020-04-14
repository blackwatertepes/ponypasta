import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import '../../lib/models/game.dart';

void main() {
  group('Game', () {
    Game game;

    setUp(() {
      game = Game.generate("123456");
    });

    group('Game.newGame', () {
      test('sets all props for a new game', () {
        expect(game.tiles.length, 25);
        expect(game.players.length, 2);
        expect(game.bombs.length, 2);
        expect(game.currentPlayer.name, 'red');
        expect(game.tiles.where((tile) => tile.ownerName == 'red').length, 7);
        expect(game.tiles.where((tile) => tile.ownerName == 'blue').length, 6);
        // expect(game.tiles.where((tile) => tile.ownerName == 'bomb').length, 2); // TODO
      });
    });

    group('endTurn', () {
      test('assign the next player to currentPlayer', () {
        expect(game.currentPlayer.name, 'red');
        game.endTurn();
        expect(game.currentPlayer.name, 'blue');
      });
    });

    group('nextPlayer', () {
      test('returns the next player in the list', () {
        expect(game.currentPlayer.name, 'red');
        expect(game.nextPlayer().name, 'blue');
      });
    });
  });
}
