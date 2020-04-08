import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

import './Player.dart';

class Tile {
  String name;
  dynamic owner;
  bool selected;

  Tile(String name, {Player owner= null, bool selected= false}) {
    this.name = name;
    this.owner = owner;
    this.selected = selected;
  }

  void select() {
    this.selected = true;
  }

  void setOwner(dynamic owner) {
    this.owner = owner;
  }

  bool hasOwner() {
    return this.owner != null;
  }

  String getName() {
    return this.name;
  }

  Player getOwner() {
    return this.owner;
  }

  bool getSelected() {
    return this.selected;
  }

  Tile.fromMap(Map<String, dynamic> map)//, {this.reference})
     : assert(map['name'] != null),
       assert(map['owner'] != null),
       assert(map['selected'] != null),
       name = map['name'],
       owner = map['owner'],
       selected = map['selected'];

  // Player.fromSnapshot(DocumentSnapshot snapshot)
  //    : this.fromMap(snapshot.data, reference: snapshot.reference);

  Tile.fromWord(String word) {
    name = word;
  }

  @override
  String toString() => "Tile<$name>";
}
