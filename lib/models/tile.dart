import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

import './Player.dart';

class Tile {
  String name;
  dynamic owner = null;
  bool selected = false;

  Tile(String name, {Player owner= null, bool selected= false}) {
    this.name = name;
    this.owner = owner;
    this.selected = selected;
  }

  void select() {
    this.selected = true;
    if (this.hasOwner()) {
      owner.incScore();
    }
  }

  bool hasOwner() {
    return this.owner != null;
  }

  // TODO: Add owner...
  Tile.fromMap(Map<dynamic, dynamic> map)//, {this.reference})
     : assert(map['name'] != null),
       assert(map['selected'] != null),
       name = map['name'],
      //  owner = map['owner'] ? Player.fromMap(map['owner']) : null,
       selected = map['selected'];

  // Player.fromSnapshot(DocumentSnapshot snapshot)
  //    : this.fromMap(snapshot.data, reference: snapshot.reference);

  Map toMap() {
    Map toReturn = new Map();
    toReturn['name'] = name;
    toReturn['owner'] = owner?.toMap();
    toReturn['selected'] = selected;
    return toReturn;
  }

  Tile.fromWord(String word) {
    name = word;
  }

  @override
  String toString() => "Tile<$name>";
}
