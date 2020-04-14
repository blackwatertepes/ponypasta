import 'package:flutter/material.dart';

import './join_game.dart';

class FindGamePage extends StatefulWidget {
  final String title;
  String roomId;

  FindGamePage({Key key, this.title}) : super(key: key);

  @override
  _FindGamePageState createState() => _FindGamePageState();
}

class _FindGamePageState extends State<FindGamePage> {

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
                    builder: (context) => JoinGamePage(title: widget.title, roomId: widget.roomId)
                  )
                );
              },
              child: Text('Find Game'),
            ),
          ),
        ]),
      )
    );
  }
}