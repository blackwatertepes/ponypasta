import 'package:flutter/material.dart';

import '../components/game.dart';
import '../components/dialogs/new_game.dart';
import '../models/game.dart';
import '../services/database.dart';

class CreateGamePage extends StatelessWidget {
  final String title;
  final String roomId;

  CreateGamePage({Key key, this.title, this.roomId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    Game game = Game.generate(this.roomId);
    DatabaseService.createRoom(game);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("${this.title} | ${this.roomId}")),
      ),
      body: GameWidget(
              title: this.title,
              roomId: this.roomId,
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
