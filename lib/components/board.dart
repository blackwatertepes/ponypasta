import 'package:flutter/material.dart';

import '../models/player.dart';
import '../models/tile.dart';

class Board extends StatelessWidget {
  Player currentPlayer;
  bool isCodeViewing;
  Function onClickTile;
  List<Tile> tiles;

  Board({
    Key key,
    this.currentPlayer,
    this.isCodeViewing,
    this.onClickTile,
    this.tiles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            colors: [this.currentPlayer.baseColor, this.currentPlayer.fillColor], // TODO
          )
        ),
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(0),
          crossAxisSpacing: 3,
          mainAxisSpacing: 3,
          crossAxisCount: 5,
          children:
            this.tiles.map((tile) => _buildTile(context, tile)).toList(),
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, Tile tile) {

    bool _canViewTile(Player owner) {
      return this.currentPlayer == owner;// || owner.name == 'bomb'; // coop can't see bombs
    }

    Color _tileColor() {
      if (tile.hasOwner() && ((this.isCodeViewing && _canViewTile(tile.owner)) || tile.selected)) {
        return tile.owner.baseColor;
      }
      return Colors.grey[300];
    }

    Color _iconColor() {
      if (tile.hasOwner() && ((this.isCodeViewing && _canViewTile(tile.owner)) || tile.selected)) {
        return tile.owner.fillColor;
      }
      return Colors.grey[300];
    }

    void _clickTile() {
      this.onClickTile(tile);
    }

    return FlatButton(
      padding: const EdgeInsets.all(0),
      child: Center(
        child: !tile.selected ?
          Text(tile.name) :
          Icon(Icons.check_circle, color: _iconColor()),
      ),
      color: _tileColor(),
      onPressed: () { _clickTile(); }
    );
  }
}