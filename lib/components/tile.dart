import 'package:flutter/material.dart';

import '../models/player.dart';
import '../models/tile.dart';

class TileWidget extends StatelessWidget {
  final Tile tile;
  final Player currentPlayer;
  final String currentTurnState;
  final onClick;

  const TileWidget({
    Key key,
    this.tile,
    this.currentPlayer,
    this.currentTurnState,
    this.onClick,
  }) : super(key: key);

  Widget build(BuildContext context) {
    bool canViewTile(Player owner) {
      return currentPlayer == owner;// || owner.name == 'bomb'; // coop can't see bombs
    }

    // DUP
    bool isCodeViewing() {
      return currentTurnState == 'code_viewing';
    }

    Color tileColor() {
      if (tile.hasOwner() && ((isCodeViewing() && canViewTile(tile.owner)) || tile.selected)) {
        return tile.owner.baseColor;
      }
      return Colors.grey[300];
    }

    return FlatButton(
      padding: const EdgeInsets.all(0),
      child: Center(
        child: Text(
          tile.name,
          style: new TextStyle(decoration: tile.selected ? TextDecoration.lineThrough : TextDecoration.none),
          textDirection: TextDirection.ltr,
        )
      ),
      color: tileColor(),
      onPressed: () { onClick(); }
    );
  }
}
