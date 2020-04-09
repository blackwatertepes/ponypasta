import 'package:flutter/material.dart';

import './game.dart';

class MenuPage extends StatefulWidget {
  MenuPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(children: <Widget>[
        FractionallySizedBox(
          widthFactor: 0.9,
          child: OutlineButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GamePage(title: widget.title))
              );
            },
            child: Text('Single Phone Game (Offline Mode)'),
          ),
        ),
        Divider(),
        FractionallySizedBox(
          widthFactor: 0.9,
          child: OutlineButton(
            onPressed: () {  },
            child: Text('Multiplayer Game (Coming Soon!)'),
          ),
        ),
      ]),
    );
  }
}
