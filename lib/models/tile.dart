import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

import './Player.dart';

class Tile {
  String name;
  Player owner = null;
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

  factory Tile.fromMap(Map<String, dynamic> map) { //, {this.reference})
    assert(map['name'] != null);
    assert(map['selected'] != null);

    Tile tile =  new Tile(
      map['name'],
    );

    if (map['owner'] != null) {
      tile.owner = Player.fromMap(map['owner']);
    }

    tile.selected = map['selected'];

    return tile;
  }

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
