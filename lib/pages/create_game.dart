import 'package:flutter/material.dart';

import '../components/game.dart';
import '../components/dialogs/new_game.dart';
import '../models/game.dart';
import '../services/database.dart';

class CreateGamePage extends StatefulWidget {
  CreateGamePage({Key key, this.title, this.roomId}) : super(key: key);

  final String title;
  final String roomId;
  Game game;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<CreateGamePage> {

  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();
    widget.game = Game.generate(widget.roomId);
    DatabaseService.createRoom(widget.game);
  }

  @override
  Widget build(BuildContext context) {
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
