import 'dart:math';
import 'package:flutter/material.dart';

import './game_online.dart';
import './game_offline.dart';
import './join_game.dart';

class MenuPage extends StatefulWidget {
  MenuPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  @override
  Widget build(BuildContext context) {

    String _generateRoomId() {
      final Random random = new Random();
      final int rand = random.nextInt(900000) + 100000;
      return rand.toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: Container(
        color: Colors.grey[100],
        child: Column(children: <Widget>[
          Container(height: 50),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Center(
              child: Text("Oddly similar to CodeNames, but totally not a rip-off."),
            ),
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
                    builder: (context) => GameOnlinePage(title: widget.title, roomId: _generateRoomId())
                  )
                );
              },
              child: Text('Create Multiplayer Game'),
            ),
          ),
          Container(height: 20),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: FlatButton(
              color: Colors.grey[300],
              splashColor: Colors.grey[200],
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JoinGamePage(title: widget.title)
                  )
                );
              },
              child: Text('Join Multiplayer Game'),
            ),
          ),
          Container(height: 50),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Center(
              child: Text("No Internet? Friend without a phone?"),
            ),
          ),
          Container(height: 20),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: FlatButton(
              color: Colors.grey[300],
              splashColor: Colors.grey[200],
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameOfflinePage(title: widget.title))
                );
              },
              child: Text('Single Phone Game (Offline Mode)')
            ),
          ),
        ]),
      )
    );
  }
}
