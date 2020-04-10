import 'package:flutter/material.dart';

import './game.dart';

class JoinGamePage extends StatefulWidget {
  JoinGamePage({Key key, this.title}) : super(key: key);

  final String title;
  String roomId;

  @override
  _JoinGamePageState createState() => _JoinGamePageState();
}

class _JoinGamePageState extends State<JoinGamePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: Container(
        color: Colors.grey[100],
        child: Column(children: <Widget>[
          Container(height: 50),
          SizedBox(
            width: 120,
            child: TextField(
              decoration: InputDecoration(labelText: 'Enter room #:'),
              keyboardType: TextInputType.number,
              onChanged: (String number) {
                widget.roomId = number;
              }
            )
          ),
          Container(height: 50),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: FlatButton(
              color: Colors.grey[300],
              splashColor: Colors.grey[200],
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GamePage(title: widget.title, roomId: widget.roomId)
                  )
                );
              },
              child: Text('Join Game'),
            ),
          ),
        ]),
      )
    );
  }
}