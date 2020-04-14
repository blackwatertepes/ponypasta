import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/game.dart';

class DatabaseService {
  static CollectionReference collection() {
    return Firestore.instance.collection('games');
  }

  static Query query(String roomId) {
    return DatabaseService.collection().where("roomId", isEqualTo: roomId).limit(1);
  }

  static Future<DocumentReference> document(String roomId) async {
    QuerySnapshot _query = await DatabaseService.query(roomId).getDocuments();
    if (_query.documents.length > 0) {
      return DatabaseService.collection().document(_query.documents.first.documentID); 
    }
  }

  static Stream<QuerySnapshot> stream(String roomId) {
    return DatabaseService.query(roomId).snapshots();
  }

  static Future<DocumentReference> createRoom(Game game) {
    return DatabaseService.collection().add(game.toMap());
  }

  static Future<DocumentReference> updateRoom(Game game) async {
    DocumentReference _doc = await DatabaseService.document(game.roomId);

    if (_doc != null) {
      _doc.updateData(game.toMap());
    }
  }
}