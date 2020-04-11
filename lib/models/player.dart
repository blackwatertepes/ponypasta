import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  String name;
  Color baseColor;
  Color fillColor;
  int tileCount;
  int score = 0;

  Player(String name, Color baseColor, Color fillColor, int tileCount) {
    this.name = name;
    this.baseColor = baseColor;
    this.fillColor = fillColor;
    this.tileCount = tileCount;
  }

  void incScore() {
    this.score++;
  }

  bool hasWon() {
    return this.score == this.tileCount;
  }

  List<bool> pips() {
    List<bool> list = new List();
    for (var i = 0; i < this.tileCount; i++) {
      if (i < this.score) {
        list.add(true);
      } else {
        list.add(false);
      }
    }
    return list;
  }

  factory Player.fromMap(Map<String, dynamic> map) { //, {this.reference})
    assert(map['name'] != null);
    assert(map['tileCount'] != null);

    Color baseColor;
    Color fillColor;

    if (map['name'] == 'red') {
      baseColor = Colors.red[100];
      fillColor = Colors.red;
    } else {
      baseColor = Colors.blue[100];
      fillColor = Colors.blue;
    }

    Player player = new Player(
      map['name'],
      baseColor,
      fillColor,
      map['tileCount'],
    );

    while (player.score < map['score']) {
      player.incScore();
    }

    return player;
  }

  // Player.fromSnapshot(DocumentSnapshot snapshot)
  //    : this.fromMap(snapshot.data, reference: snapshot.reference);

  Map toMap() {
    Map toReturn = new Map();
    toReturn['name'] = name;
    toReturn['tileCount'] = tileCount;
    toReturn['score'] = score;
    return toReturn;
  }

  @override
  String toString() => "Player<$name>";
}
