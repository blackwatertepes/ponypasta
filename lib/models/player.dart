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

  Player.fromMap(Map<String, dynamic> map)//, {this.reference})
     : assert(map['name'] != null),
       assert(map['baseColor'] != null),
       assert(map['fillColor'] != null),
       assert(map['tileCount'] != null),
       name = map['name'],
       baseColor = map['baseColor'],
       fillColor = map['fillColor'],
       tileCount = map['tileCount'];

  // Player.fromSnapshot(DocumentSnapshot snapshot)
  //    : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Player<$name>";
}
