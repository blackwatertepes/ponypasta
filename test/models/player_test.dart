import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import '../../lib/models/player.dart';

void main() {
  group('Player', () {
    Player player;

    setUp(() {
      player = new Player('red', Colors.red[100], Colors.red, 9);
    });

    test('increments the score from 0', () {
      expect(player.score, 0);
      player.incScore();
      expect(player.score, 1);
    });

    test('shows a winner', () {
      expect(player.hasWon(), false);
      while (player.score < player.tileCount) {
        player.incScore();
      }
      expect(player.hasWon(), true);
    });

    test('shows the proper amount of pips', () {
      expect(player.pips().where((pip) => pip).length, 0);
      player.incScore();
      expect(player.pips().where((pip) => pip == true).length, 1);
    });
  });
}
