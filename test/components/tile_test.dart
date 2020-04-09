import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:codefriendsflutter/components/tile.dart';
import 'package:codefriendsflutter/models/player.dart';
import 'package:codefriendsflutter/models/tile.dart';

void main() {
  testWidgets('TileWidget', (WidgetTester tester) async {
    final Tile tile = new Tile('alpha');
    final Player player = new Player('red', Colors.red, Colors.red, 1);

    void onClick() {
    };

    await tester.pumpWidget(TileWidget(
      tile: tile,
      currentPlayer: player,
      currentTurnState: 'code_viewing',
      onClick: onClick,
    ));

    expect(find.text('alpha'), findsOneWidget);

    // await tester.tap(find.text("alpha"));
    // await tester.pump();
  });
}
