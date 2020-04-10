import 'package:flutter/material.dart';

import '../models/player.dart';

class Pips extends StatelessWidget {
  List<Player> players;

  Pips({
    Key key,
    this.players,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: this.players.map((player) => _buildPlayerPips(context, player)).toList()
    );
  }

  Widget _buildPlayerPips(BuildContext context, Player player) {
    return Expanded(
      child: Row(
        children: player.pips().map((filled) => _buildPlayerPip(context, player.fillColor, player.baseColor, filled)).toList(),
      ),
    );
  }

  Widget _buildPlayerPip(BuildContext context, Color fillColor, Color baseColor, bool filled) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(2.0),
        height: 10,
        color: filled ? fillColor : baseColor
      )
    );
  }
}