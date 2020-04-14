import 'package:flutter/material.dart';

import './create_game.dart';
import './game_offline.dart';
import './find_game.dart';
import '../utils.dart';

class MenuPage extends StatelessWidget {
  final String title;

  MenuPage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(this.title)),
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
                    builder: (context) => CreateGamePage(title: this.title, roomId: generateRandom(1000000).toString())
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
                    builder: (context) => FindGamePage(title: this.title)
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
                  MaterialPageRoute(builder: (context) => GameOfflinePage(title: this.title))
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
