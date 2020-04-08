import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import '../../lib/models/player.dart';

void main() {
  group('Player', () {
    Player player;
    int tileCount = 9;

    setUp(() {
      player = new Player('red', Colors.red[100], Colors.red, tileCount);
    });

    test('init', () {
      expect(player.score, 0);
      expect(player.hasWon(), false);
      expect(player.pips().where((pip) => pip).length, 0);
    });

    group('when the score increments', () {
      setUp(() {
        player.incScore();
      });

      test('shows the score & pips correctly', () {
        expect(player.score, 1);
        expect(player.pips().where((pip) => pip).length, 1);
        expect(player.hasWon(), false);
      });
    });

    group('when the score increments to a victory', () {
      setUp(() {
        while (player.score < player.tileCount) {
          player.incScore();
        }
      });

      test('shows a winner', () {
        expect(player.score, tileCount);
        expect(player.pips().where((pip) => pip).length, tileCount);
        expect(player.hasWon(), true);
      });
    });
  });
}
