import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../components/game.dart';
import '../components/dialogs/new_game.dart';
import '../models/game.dart';
import '../models/player.dart';
import '../models/tile.dart';
import '../utils/game.dart';

class CreateGamePage extends StatefulWidget {
  CreateGamePage({Key key, this.title, this.roomId}) : super(key: key);

  final String title;
  final String roomId;
  List<Tile> tiles = List();
  List<Player> players = List();
  List<Player> bombs = List();
  Player currentPlayer;
  DocumentReference gameDoc;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<CreateGamePage> {

  @override
  void initState() {
    super.initState();

    newGame(widget);
    _createRoom();
  }

  Future<void> _createRoom() async {
    Game game = Game(
      widget.roomId,
      widget.tiles,
      widget.players,
      widget.bombs,
      widget.currentPlayer,
    );

    WidgetsFlutterBinding.ensureInitialized();
    CollectionReference _gamesCol = Firestore.instance.collection("games");

    widget.gameDoc = await _gamesCol.add(game.toMap());
  }

  @override
  Widget build(BuildContext context) {

    Future<void> _updateRoom() async {
      Game game = Game(
        widget.roomId,
        widget.tiles,
        widget.players,
        widget.bombs,
        widget.currentPlayer,
      );

      await widget.gameDoc.updateData(game.toMap());
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("${widget.title} | ${widget.roomId}")),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            GamePage(
              title: widget.title,
              roomId: widget.roomId,
              isPlayer: 'red'
            ),
            Divider(),
            FractionallySizedBox(
              widthFactor: 0.9,
              child: OutlineButton(
                onPressed: () { neverSatisfied(context, () {
                  setState(() => newGame(widget));
                  _updateRoom();
                }); },
                child: const Text('New Game'),
              ),
            ),
          ]
        )
      )
    );
  }
}
