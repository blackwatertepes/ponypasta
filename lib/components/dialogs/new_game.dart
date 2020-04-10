import 'package:flutter/material.dart';

Future<void> neverSatisfied(context, resetGame) async {
  String body() {
    return 'You will never be satisfied.';
  }

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Start a new Game'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(body()),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('New Game'),
            onPressed: () {
              Navigator.of(context).pop();
              resetGame();
            },
          ),
        ],
      );
    },
  );
}