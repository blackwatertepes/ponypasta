import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../components/game.dart';
import '../components/dialogs/new_game.dart';
import '../models/game.dart';

class CreateGamePage extends StatefulWidget {
  CreateGamePage({Key key, this.title, this.roomId}) : super(key: key);

  final String title;
  final String roomId;
  DocumentReference gameDoc;
  Game game;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<CreateGamePage> {

  @override
  void initState() {
    super.initState();

    widget.game = Game.generate(widget.roomId);
    _createRoom();
  }

  Future<void> _createRoom() async {
    WidgetsFlutterBinding.ensureInitialized();
    CollectionReference _gamesCol = Firestore.instance.collection("games");

    widget.gameDoc = await _gamesCol.add(widget.game.toMap());
  }

  @override
  Widget build(BuildContext context) {

    Future<void> _updateRoom() async {
      await widget.gameDoc.updateData(widget.game.toMap());
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("${widget.title} | ${widget.roomId}")),
      ),
      body: GamePage(
              title: widget.title,
              roomId: widget.roomId,
              isPlayer: 'red'
            // Divider(),
            // FractionallySizedBox(
            //   widthFactor: 0.9,
            //   child: OutlineButton(
            //     onPressed: () { neverSatisfied(context, () {
            //       setState(() => newGame(widget.game));
            //       _updateRoom();
            //     }); },
            //     child: const Text('New Game'),
            //   ),
            // ),
      )
    );
  }
}
