import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import '../../lib/models/player.dart';
import '../../lib/models/tile.dart';

void main() {
  group('Tile', () {
    Tile tile;
    Player player;

    setUp(() {
      tile = new Tile('alpha');
      player = new Player('red', Colors.red[100], Colors.red, 9);
    });

    test('init', () {
      expect(tile.owner, null);
      expect(tile.selected, false);
      expect(tile.hasOwner(), false);
    });

    group('when assigned', () {
      setUp(() {
        tile.owner = player;
      });

      test('has an owner', () {
        expect(tile.hasOwner(), true);
      });

      group('when selected', () {
        setUp(() {
          tile.select();
        });

        test('increments the score for the owner', () {
          expect(tile.selected, true);
          expect(tile.owner.score, 1);
        });
      });
    });
  });
}
