import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class Tile {
  String name;
  String ownerName = null;
  bool selected = false;

  Tile(String name, {String ownerName= null, bool selected= false}) {
    this.name = name;
    this.ownerName = ownerName;
    this.selected = selected;
  }

  String select() {
    this.selected = true;
    return this.ownerName;
  }

  bool hasOwner() {
    return this.ownerName != null;
  }

  factory Tile.fromMap(Map<String, dynamic> map) { //, {this.reference})
    assert(map['name'] != null);
    assert(map['selected'] != null);

    Tile tile =  new Tile(
      map['name'],
    );

    tile.ownerName = map['ownerName'];
    tile.selected = map['selected'];

    return tile;
  }

  // Player.fromSnapshot(DocumentSnapshot snapshot)
  //    : this.fromMap(snapshot.data, reference: snapshot.reference);

  Map toMap() {
    Map toReturn = new Map();
    toReturn['name'] = name;
    toReturn['ownerName'] = ownerName;
    toReturn['selected'] = selected;
    return toReturn;
  }

  Tile.fromWord(String word) {
    name = word;
  }

  @override
  String toString() => "Tile<$name>";
}
