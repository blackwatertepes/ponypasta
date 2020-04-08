import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:codefriendsflutter/main.dart';

void main() {
  testWidgets('displays a 2p game & hits all the buttons', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Pony Pasta'), findsOneWidget);

    expect(find.text('New Game'), findsOneWidget);

    // End code viewers turn...
    await tester.tap(find.text("End Turn (Hide Codes)"));
    await tester.pump();

    expect(find.text('Begin Turn (View Codes 4 blue)'), findsOneWidget);

    // End code guessers turn...
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();

    expect(find.text('End Turn (Hide Codes)'), findsOneWidget);

    // End code viewers turn...
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();

    expect(find.text('End Turn (Hide Codes)'), findsNothing);

    // Start a new game...
    await tester.tap(find.text("New Game"));
    await tester.pump();

    expect(find.text('Start a new Game'), findsOneWidget);

    // Confirm...
    await tester.tap(find.text("New Game").last);
    await tester.pump();

    expect(find.text('Start a new Game'), findsNothing);
    expect(find.text('End Turn (Hide Codes)'), findsOneWidget);
  });
}
