import 'package:flutter/material.dart';

import './game_online.dart';
import './game_offline.dart';

class MenuPage extends StatefulWidget {
  MenuPage({Key key, this.title}) : super(key: key);

  final String title;
  String roomId = '';

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  @override
  Widget build(BuildContext context) {

    bool _hasRoomNumber() {
      return widget.roomId.length >= 4;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(children: <Widget>[
        SizedBox(
          width: 120,
          child: TextField(
            decoration: InputDecoration(labelText: 'Enter room #:'),
            keyboardType: TextInputType.number,
            onChanged: (String number) {
              widget.roomId = number;
            }
          ),
        ),
        Divider(),
        FractionallySizedBox(
          widthFactor: 0.9,
          child: OutlineButton(
            onPressed: () {
              if (_hasRoomNumber()) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameOnlinePage(title: widget.title, roomId: widget.roomId)
                  )
                );
              }
            },
            child: Text('Multiplayer Game'),
          ),
        ),
        Divider(),
        FractionallySizedBox(
          widthFactor: 0.9,
          child: OutlineButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GameOfflinePage(title: widget.title))
              );
            },
            child: Text('Single Phone Game (Offline Mode)'),
          ),
        ),
      ]),
    );
  }
}
